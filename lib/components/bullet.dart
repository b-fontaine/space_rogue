import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_rogue/game/rogue_shooter.dart';

import 'boss.dart';
import 'ennemy.dart';

class BulletComponent extends SpriteAnimationComponent
    with HasGameRef<RogueShooterGame>, CollisionCallbacks {
  static const speed = 500.0;
  late final Vector2 velocity;
  final Random random = Random();
  final Vector2 deltaPosition = Vector2.zero();

  BulletComponent({required super.position, super.angle})
      : super(size: Vector2(10, 20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    double randomVolume = 0.02 + random.nextDouble() * 0.06;
    gameRef.bulletPool.start(volume: randomVolume);

    add(CircleHitbox());
    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(8, 16),
      ),
    );
    velocity = Vector2(0, -1)
      ..rotate(angle)
      ..scale(speed);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EnemyComponent) {
      other.takeHit();
      removeFromParent();
    }
    if (other is BossComponent) {
      other.takeHit();
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    deltaPosition
      ..setFrom(velocity)
      ..scale(dt);
    position += deltaPosition;

    if (position.y < 0 || position.x > game.size.x || position.x + size.x < 0) {
      removeFromParent();
    }
  }
}
