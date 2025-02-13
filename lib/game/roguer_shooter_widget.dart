import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:space_rogue/components/title_screen.dart';

import 'rogue_shooter.dart';

class RogueShooterWidget extends StatelessWidget {
  const RogueShooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final game = RogueShooterGame();

    return GameWidget<RogueShooterGame>(
      game: game,
      loadingBuilder: (_) => const Center(
        child: Text('Loading'),
      ),
      overlayBuilderMap: {
        'TitleScreen': (context, game) => TitleScreen(game: game),
      },
      initialActiveOverlays: const ['TitleScreen'],
    );
  }
}
