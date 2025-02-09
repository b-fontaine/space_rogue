import 'package:flame/components.dart';

import 'star_background.dart';

class StarComponent extends SpriteAnimationComponent with HasGameRef {
  StarComponent({super.animation, super.position})
      : super(size: Vector2.all(20));

  @override
  void update(double dt) {
    super.update(dt);
    y += dt * StarBackGroundCreator.speed;
    if (y >= game.size.y) {
      removeFromParent();
    }
  }
}
