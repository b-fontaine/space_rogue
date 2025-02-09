import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'star.dart';

class StarBackGroundCreator extends Component with HasGameRef {
  final gapSize = 12;
  static int _speed = 50;
  static final StreamController<int> _speedController = StreamController<int>();
  static final Stream<int> _speedStream =
      _speedController.stream.asBroadcastStream();

  static int get speed => _speed;

  static set speed(int value) {
    _speed = value;
    _speedController.sink.add(value);
  }

  late final SpriteSheet spriteSheet;
  late final TimerComponent _timerComponent;
  Random random = Random();

  StarBackGroundCreator();

  @override
  Future<void> onLoad() async {
    spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await game.images.load('stars.png'),
      rows: 4,
      columns: 4,
    );

    final starGapTime = (game.size.y / gapSize) / speed;
    add(
      TimerComponent(
        period: starGapTime,
        repeat: true,
        onTick: () => _createRowOfStars(0),
      ),
    );

    _speedStream.listen((speed) {
      final starGapTime = (game.size.y / gapSize) / speed;
      removeWhere((c) => c is TimerComponent);
      add(
        TimerComponent(
          period: starGapTime,
          repeat: true,
          onTick: () => _createRowOfStars(0),
        ),
      );
    });

    _createInitialStars();
  }

  void _createStarAt(double x, double y) {
    final animation = spriteSheet.createAnimation(
      row: random.nextInt(3),
      to: 4,
      stepTime: 0.1,
    )..variableStepTimes = [max(20, 100 * random.nextDouble()), 0.1, 0.1, 0.1];

    game.add(StarComponent(animation: animation, position: Vector2(x, y)));
  }

  void _createRowOfStars(double y) {
    const gapSize = 6;
    final starGap = game.size.x / gapSize;

    for (var i = 0; i < gapSize; i++) {
      _createStarAt(
        starGap * i + (random.nextDouble() * starGap),
        y + (random.nextDouble() * 20),
      );
    }
  }

  void _createInitialStars() {
    final rows = game.size.y / gapSize;

    for (var i = 0; i < gapSize; i++) {
      _createRowOfStars(i * rows);
    }
  }
}
