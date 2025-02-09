import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../game/rogue_shooter.dart';
import 'explosion.dart';

class BossComponent extends SpriteAnimationComponent
    with HasGameReference<RogueShooterGame>, CollisionCallbacks {
  static const defaultSpeed = 150;

  final int speed;
  int lifes = 3;

  BossComponent({
    required super.position,
    this.speed = defaultSpeed,
  }) : super(size: Vector2(58, 192), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final starGapTime = (game.size.y / 12) / speed;
    animation = await game.loadSpriteAnimation(
      'boss.png',
      SpriteAnimationData.sequenced(
        stepTime: starGapTime / 2,
        amount: 4,
        textureSize: Vector2(29, 96),
      ),
    );
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    final delta = speed * dt;
    y += delta;
    if (y >= game.size.y) {
      removeFromParent();
    }
    final angle = Random().nextDouble() * delta - (delta / 2);
    x += angle;
    if (x < 0) {
      x = 0;
    }
    if (x > game.size.x) {
      x = game.size.x;
    }
  }

  void takeHit() {
    game.add(ExplosionComponent(position: position));
    lifes--;

    if (lifes == 0) {
      removeFromParent();
      game.bossDown();
    }
  }
}
