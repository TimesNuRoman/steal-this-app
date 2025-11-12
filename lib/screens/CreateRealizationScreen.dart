import 'package:flutter/material.dart';
import 'package:steal_this_app/models/Idea.dart';
import 'package:steal_this_app/services/ApiService.dart';

class CreateRealizationScreen extends StatefulWidget {
  final Idea idea;

  const CreateRealizationScreen({required this.idea});

  @override
  _CreateRealizationScreenState createState() => _CreateRealizationScreenState();
}

class _CreateRealizationScreenState extends State<CreateRealizationScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сделай из этого что-то'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Ты украл идею: "${widget.idea.content}"'),
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Опиши, что ты сделал'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  ApiService.createRealization(widget.idea.id, _controller.text);
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
