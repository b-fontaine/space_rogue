import 'dart:math';

import 'package:flame/components.dart';

import 'ennemy.dart';

class EnnemyCreator extends TimerComponent with HasGameRef {
  final Random random = Random();
  final _halfWidth = Vector2.all(25).x / 2;
  int level = 1;
  bool finished = false;

  int get currentSpeed => EnemyComponent.defaultSpeed + level * 20;

  EnnemyCreator() : super(period: 1, repeat: true);

  @override
  void onTick() {
    if (finished) {
      return;
    }
    if (level > 20) {
      final newHalfWidth = Vector2.all(60).x / 2;
      game.add(
        EnemyComponent(
          dimension: 60,
          position: Vector2(
            newHalfWidth + (game.size.x - newHalfWidth) * random.nextDouble(),
            random.nextDouble() * (game.size.y / 5),
          ),
          speed: EnemyComponent.defaultSpeed,
        ),
      );
    } else {
      game.addAll(
        List.generate(
          level + 1,
          (index) => EnemyComponent(
            position: Vector2(
              _halfWidth + (game.size.x - _halfWidth) * random.nextDouble(),
              random.nextDouble() * (game.size.y / 5),
            ),
            speed: currentSpeed,
          ),
        ),
      );
    }
  }
}
