import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flutter/services.dart';
import 'package:frontend/Screens/pixel/components/Utils.dart';
import 'package:frontend/Screens/pixel/components/checkpoint.dart';
import 'package:frontend/Screens/pixel/components/chicken.dart';
import 'package:frontend/Screens/pixel/components/collision_block.dart';
import 'package:frontend/Screens/pixel/components/custom_hitbox.dart';
import 'package:frontend/Screens/pixel/components/fruit.dart';
import 'package:frontend/Screens/pixel/components/level.dart';
import 'package:frontend/Screens/pixel/components/saw.dart';
import 'package:frontend/Screens/pixel/pixel_adventure.dart';
import 'package:frontend/Screens/pixel/services/audio_manager.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
  disappearing,
}

//Group of animations : Jump fall move etcetra
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  final AudioManager audioManager = AudioManager();
  String character;
  Player({position, this.character = 'Ninja Frog'}) : super(position: position);

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 260; //280 before
  final double _terminalVelocity = 300;

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool gotHit = false;
  bool reachedCheckpoint = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  @override
  FutureOr<void> onLoad() async {
    _LoadAllAnimations();
    await audioManager.onLoad();
    //debugMode = true;
    startingPosition = Vector2(position.x, position.y); //Where we started

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollision();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }

      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.space);
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  Future<void> onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) async {
    //
    if (!reachedCheckpoint) {
      if (other is Fruit) {
        String collectedFruit =
            await other.collidedWithPlayer(); //--String 1,2,3
        print("Collected: $collectedFruit"); // Debugging output

        // Update the level's fruit text
        (parent as Level).displayFruitName(collectedFruit);
      }
      //
      if (other is Saw) _respawn();
      if (other is Chicken) other.collidedWithPlayer();
      if (other is Checkpoint) _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _LoadAllAnimations() {
    idleAnimation = _spriteAnimation("Idle", 11);
    runningAnimation = _spriteAnimation("Run", 12);
    jumpingAnimation = _spriteAnimation("Jump", 1);
    fallingAnimation = _spriteAnimation("Fall", 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation("Appearing", 7);
    disappearingAnimation = _specialSpriteAnimation("Desappearing", 7);

    //List of All Animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    //Set current Animation
    current = PlayerState.idle;
  }

  //Method for Creating any animation with ease
  SpriteAnimation _spriteAnimation(String State, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$State (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  //appear diappear
  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter(); //chnage face sidess
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    //check if moving ..sets running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    //check if falling ..sets falling
    if (velocity.y > 0) {
      playerState = PlayerState.falling;
    }

    //check if jumping ..sets jumping
    if (velocity.y < 0) {
      playerState = PlayerState.jumping;
    }
    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);
    // if(velocity.y > _gravity) isOnGround = false;
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    if (game.playSounds) audioManager.play('jump.wav');
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollision() {
    for (final block in collisionBlocks) {
      //handle collision
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0; //stop going right
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0; //stop going left
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _respawn() async {
    if (game.playSounds) audioManager.play('hit.wav');
    const canMoveDuration = Duration(milliseconds: 400);
    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(canMoveDuration, () => gotHit = false);
  }

  void _reachedCheckpoint() async {
    reachedCheckpoint = true;
    if (game.playSounds) {
      audioManager.play('disappear.wav');
    }
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640);

    const waitToChangeDuration = Duration(seconds: 3);
    Future.delayed(waitToChangeDuration, () => game.loadNextLevel());
  }

  void collidedwithEnemy() {
    _respawn();
  }
}
