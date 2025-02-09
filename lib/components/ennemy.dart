import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../game/rogue_shooter.dart';
import 'explosion.dart';

class EnemyComponent extends SpriteAnimationComponent
    with HasGameReference<RogueShooterGame>, CollisionCallbacks {
  static const defaultSpeed = 150;

  final int speed;
  final double dimension;

  EnemyComponent({
    required super.position,
    this.speed = defaultSpeed,
    this.dimension = 25,
  }) : super(size: Vector2.all(dimension), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final starGapTime = (game.size.y / 12) / speed;
    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        stepTime: starGapTime,
        amount: 4,
        textureSize: Vector2.all(16),
      ),
    );
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
    if (y >= game.size.y) {
      removeFromParent();
    }
  }

  void takeHit() {
    removeFromParent();

    game.add(ExplosionComponent(position: position));
    if (dimension == 25) {
      game.increaseScore();
    } else {
      game.bossDown();
    }
  }
}
