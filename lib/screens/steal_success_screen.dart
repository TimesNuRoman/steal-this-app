import 'package:flutter/material.dart';
import 'create_realization_screen.dart';
import '../models/idea.dart';

class StealSuccessScreen extends StatelessWidget {
  final Idea idea;

  const StealSuccessScreen({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.done, size: 100, color: Colors.green),
            const Text('Украдено. Теперь это твоё.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateRealizationScreen(idea: idea)),
                );
              },
              child: const Text('Сделать из этого что-то'),
            ),
          ],
        ),
      ),
    );
  }
}
