import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:frontend/Screens/pixel/components/custom_hitbox.dart';
import 'package:frontend/Screens/pixel/pixel_adventure.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String fruit;
  Fruit({required this.fruit, position, size})
      : super(position: position, size: size);

  final double stepTime = 0.05; // Animation Time
  final hitBox = CustomHitbox(offsetX: 10, offsetY: 10, width: 12, height: 12);
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitBox.offsetX, hitBox.offsetY),
        size: Vector2(hitBox.width, hitBox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  Future<String> collidedWithPlayer() async {
    if (!collected) {
      collected = true;
      // Increment the global fruit count in PixelAdventure
      // game.fruitCount++;

      // Debug print to check if fruitCount updates
      // print('Fruit Collected: ${game.fruitCount}');

      if (game.playSounds) {
        FlameAudio.play('collect_fruit.wav', volume: game.soundVolume);
      }

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );

      await animationTicker?.completed;
      removeFromParent();
    }
    return fruit;
  }
}
