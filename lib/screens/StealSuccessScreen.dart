import 'package:flutter/material.dart';
import 'CreateRealizationScreen.dart';
import '../models/Idea.dart';

class StealSuccessScreen extends StatelessWidget {
  final Idea idea;

  const StealSuccessScreen({required this.idea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.done, size: 100, color: Colors.green),
            Text('Украдено. Теперь это твоё.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateRealizationScreen(idea: idea)),
                );
              },
              child: Text('Сделать из этого что-то'),
            ),
          ],
        ),
      ),
    );
  }
}
