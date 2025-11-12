import 'package:flutter/material.dart';
import 'package:steal_this_app/models/Idea.dart';
import 'package:steal_this_app/services/ApiService.dart';

class CreateIdeaScreen extends StatefulWidget {
  @override
  _CreateIdeaScreenState createState() => _CreateIdeaScreenState();
}

class _CreateIdeaScreenState extends State<CreateIdeaScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новая идея'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Напиши идею...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  ApiService.createIdea(_controller.text);
                  Navigator.pop(context);
                }
              },
              child: Text('Опубликовать'),
            ),
          ],
        ),
      ),
    );
  }
}
