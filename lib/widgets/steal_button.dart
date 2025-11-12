import 'package:flutter/material.dart';
import '../models/idea.dart';
import '../screens/steal_success_screen.dart';
import '../services/firestore_service.dart';

class StealButton extends StatelessWidget {
  final Idea idea;

  const StealButton({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FirestoreService.stealIdea(idea.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StealSuccessScreen(idea: idea)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text('Украсть'),
    );
  }
}
