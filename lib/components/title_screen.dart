import 'package:flutter/material.dart';
import 'package:space_rogue/game/rogue_shooter.dart';

class TitleScreen extends StatelessWidget {
  final RogueShooterGame game;

  const TitleScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material( // Ensure Material context for buttons
      color: Colors.black, // Background color to avoid grey screen
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Space Rogue', // Change this to your game title
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                game.startGame();
              },
              child: const Text(
                'START',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}