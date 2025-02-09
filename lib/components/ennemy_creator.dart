import 'dart:math';

import 'package:flame/components.dart';

import 'boss.dart';
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
      game.add(
        BossComponent(
          position: Vector2(
            15 + (game.size.x - 15) * random.nextDouble(),
            0,
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
