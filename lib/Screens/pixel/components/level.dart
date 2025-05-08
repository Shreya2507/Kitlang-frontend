import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:frontend/Screens/pixel/components/background_tile.dart';
import 'package:frontend/Screens/pixel/components/checkpoint.dart';
import 'package:frontend/Screens/pixel/components/chicken.dart';
import 'package:frontend/Screens/pixel/components/collision_block.dart';
import 'package:frontend/Screens/pixel/components/fruit.dart';
import 'package:frontend/Screens/pixel/components/player.dart';
import 'package:frontend/Screens/pixel/components/saw.dart';
import 'package:frontend/Screens/pixel/pixel_adventure.dart';
import 'package:frontend/Screens/pixel/services/audio_manager.dart';
import 'package:frontend/Screens/pixel/services/translation_service.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  final AudioManager audioManager = AudioManager();

  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];
  late TextComponent fruitText;

  final FlutterTts tts = FlutterTts();

  //Map from url

  Map<String, String> translationMap = {};
  List<String> fruitKeys = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    _scrollingBackground();
    await translateMyFruits(); // <-- Wait for fruitKeys and translationMap to be ready
    _spawningObjects();
    _addCollisions();

    // Load audio before playing
    await add(audioManager);

    // Add Fruit Name Display
    fruitText = TextComponent(
      text: '',
      position: Vector2(610 / 2, 10), // Top-center
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 245, 245, 243),
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
        ),
      ),
    );
    add(fruitText);

    return super.onLoad();
  }

  // Method to update fruit name - called in player  updateFruitName(fruitIndex);
  void displayFruitName(String fruitName) {
    // // Define German translations
    // final Map<String, String> translations = {
    //   "Apple": "Apfel",
    //   "Bananas": "Banane",
    //   "Cherries": "Kirsche",
    //   "Orange": "Orange",
    //   "Strawberry": "Erdbeere",
    //   "Pineapple": "Ananas",
    //   "Kiwi": "Kiwi",
    //   "Melon": "Wassermelone",
    // };

    // // Get the German translation or use the original name if not found
    // String germanTranslation = translations[fruitName] ?? fruitName;

    // // Update text with translation
    // fruitText.text = "$fruitName is $germanTranslation";

    // // Play corresponding audio

    // audioManager.play("$germanTranslation.wav");

    // // Animate text (assuming animateText() exists)
    // animateText();

    // // Clear text after 2 seconds
    // Future.delayed(const Duration(seconds: 2), () {
    //   fruitText.text = "";
    // });
    final germanName = translationMap[fruitName]; // e.g., "Apfel"
    fruitText.text = "$fruitName is $germanName";

    // Play corresponding audio
    if (germanName != null) {
      tts.speak(germanName); // Speak the German name
    }

    // audioManager.play("$germanName.wav");

    // Animate text (assuming animateText() exists)
    animateText();

    // Clear text after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      fruitText.text = "";
    });
  }

  // Method to animate the fruit name text
  void animateText() {
    fruitText.add(
      ScaleEffect.to(
        Vector2.all(1.2), // Slightly bigger effect
        EffectController(duration: 0.1, reverseDuration: 0.1),
      ),
    );
  }

  //sending list --> Translate map getting from the url
  Future<void> translateMyFruits() async {
    List<String> myFruitList = [
      "Apple",
      "Bananas",
      "Cherries",
      "Orange",
      "Strawberry",
      "Pineapple",
      "Kiwi",
      "Melon",
    ];

    try {
      translationMap = await TranslationService.getGermanTranslations(
        myFruitList,
      );

      print("Translations:");
      translationMap.forEach((english, german) {
        print('$english → $german');
      });
    } catch (e) {
      print('Something went wrong: $e');
    }
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    if (backgroundLayer != null) {
      final backgroundColor = backgroundLayer.properties.getValue(
        'BackgroundColor',
      );
      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? 'Gray',
        position: Vector2(-50, 50),
      );
      add(backgroundTile);
    }
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            add(player);
            break;
          case 'Fruit':
            // final fruit = Fruit(
            //   fruit: spawnPoint.name,
            //   position: Vector2(spawnPoint.x, spawnPoint.y),
            //   size: Vector2(spawnPoint.width, spawnPoint.height),
            // );
            // add(fruit);
            // break;
            // Convert spawnPoint.name (e.g. "0") to int index
            final int? index = int.tryParse(spawnPoint.name);
            final fruitKeys = translationMap.keys.toList();

            if (index != null && index >= 0 && index < translationMap.length) {
              final fruitName = fruitKeys[index]; // e.g., "Apple"

              // print('Spawned fruit: $fruitName');
              final fruit = Fruit(
                fruit: fruitName,
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height),
              );
              add(fruit);
              // updateFruitName(fruitName);
            } else {
              print('Invalid fruit index: ${spawnPoint.name}');
            }
            break;

          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          case 'Chicken':
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final chicken = Chicken(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: offNeg,
              offPos: offPos,
            );
            add(chicken);
            break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
