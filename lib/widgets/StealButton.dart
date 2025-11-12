import 'package:flutter/material.dart';
import 'package:steal_this_app/models/Idea.dart';
import 'package:steal_this_app/services/ApiService.dart';
import '../screens/StealSuccessScreen.dart';

class StealButton extends StatelessWidget {
  final Idea idea;

  const StealButton({required this.idea});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ApiService.stealIdea(idea.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StealSuccessScreen(idea: idea)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: Text('Украсть'),
    );
  }
}
