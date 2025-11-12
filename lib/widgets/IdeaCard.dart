import 'package:flutter/material.dart';
import 'package:steal_this_app/models/Idea.dart';
import 'StealButton.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;

  const IdeaCard({required this.idea});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              idea.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'от ${idea.authorName}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('${idea.stealCount} угонов'),
                Spacer(),
                StealButton(idea: idea),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
