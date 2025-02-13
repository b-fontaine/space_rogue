import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

import '../components/ennemy_creator.dart';
import '../components/player.dart';
import '../components/star_background.dart';

class RogueShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection, HasPerformanceTracker {
  static const String description = '''
    A simple space shooter game used for testing performance of the collision
    detection system in Flame.
  ''';

  late final AudioPool _bulletPool;
  late final PlayerComponent _player;
  late final TextComponent _componentCounter;
  late final TextComponent _scoreText;
  late final Component _background;
  late final EnnemyCreator _ennemies;

  int _life = 10;

  final _updateTime = TextComponent(
    text: 'lifes: 10',
    position: Vector2(0, 0),
    priority: 1,
  );

  int _score = 0;

  @override
  Future<void> onLoad() async {
    // Load audio
    await FlameAudio.audioCache.load('alienshoot1.wav');
    _bulletPool = await FlameAudio.createPool(
      'alienshoot1.wav',
      minPlayers: 1,
      maxPlayers: 20,
    );

    _player = PlayerComponent();
    _ennemies = EnnemyCreator();
    _background = StarBackGroundCreator();
    _scoreText = TextComponent(
        position: size - Vector2(0, 25),
        anchor: Anchor.bottomRight,
        priority: 1,
      );
    _componentCounter = TextComponent(
      position: size,
      anchor: Anchor.bottomRight,
      priority: 1,
    );
  }

  startGame() {
    overlays.remove('TitleScreen');

    bulletPool.start(volume: 0);

    add(_player);

    addAll([
      FpsTextComponent(
        position: size - Vector2(0, 50),
        anchor: Anchor.bottomRight,
      ),
      _scoreText,
      _componentCounter,
    ]);

    add(_ennemies);
    add(_background);

    addAll([_updateTime]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scoreText.text = 'Score: $_score';
    _componentCounter.text = 'Components: ${children.length}';
    _updateTime.text = 'Lifes: $_life';
  }

  @override
  void onPanStart(info) {
    _player.beginFire();
  }

  @override
  void onPanEnd(info) {
    _player.stopFire();
  }

  @override
  void onPanCancel() {
    _player.stopFire();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _player.position += info.delta.global;
  }

  AudioPool get bulletPool => _bulletPool;

  void takeHit() {
    _life--;
    _updateTime.text = 'Lifes: $_life';
    if (_life == 0) {
      _ennemies.finished = true;
      StarBackGroundCreator.speed = 50;
      remove(_player);
      add(TextComponent(
        text: 'Game Over',
        position: Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center,
        priority: 1,
      ));
    }
  }

  void increaseScore() {
    _score++;
    int level = _score ~/ 10;
    if (level < 30) {
      _ennemies.level = level;
    }
    StarBackGroundCreator.speed = 100 + level * 10;
  }

  void bossDown() {
    _ennemies.finished = true;
    StarBackGroundCreator.speed = 50;
    add(TextComponent(
      text: 'You win !',
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      priority: 1,
    ));
  }
}
