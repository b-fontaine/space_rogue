import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../game/rogue_shooter.dart';
import 'boss.dart';
import 'bullet.dart';
import 'ennemy.dart';
import 'explosion.dart';

class PlayerComponent extends SpriteAnimationComponent
    with HasGameReference<RogueShooterGame>, CollisionCallbacks {
  late TimerComponent bulletCreator;

  PlayerComponent() : super(size: Vector2(50, 75), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    position = game.size / 2;
    add(CircleHitbox());
    add(
      bulletCreator = TimerComponent(
        period: 0.2,
        repeat: true,
        autoStart: false,
        onTick: _createBullet,
      ),
    );
    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(32, 39),
      ),
    );
  }

  final _bulletAngles = [0.0]; //[0.5, 0.3, 0.0, -0.5, -0.3];
  void _createBullet() {
    game.addAll(
      _bulletAngles.map(
        (angle) => BulletComponent(
          position: position + Vector2(0, -size.y / 2),
          angle: angle,
        ),
      ),
    );
  }

  void beginFire() {
    bulletCreator.timer.start();
  }

  void stopFire() {
    bulletCreator.timer.pause();
  }

  void takeHit() {
    game.add(ExplosionComponent(position: position));
    game.takeHit();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EnemyComponent || other is BossComponent) {
      takeHit();
    }
  }
}
