import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../services/firestore_service.dart';

class CreateCommentScreen extends StatefulWidget {
  final String targetId;
  final String targetType;
  final String targetTitle;

  const CreateCommentScreen({
    super.key,
    required this.targetId,
    required this.targetType,
    required this.targetTitle,
  });

  @override
  State<CreateCommentScreen> createState() => _CreateCommentScreenState();
}

class _CreateCommentScreenState extends State<CreateCommentScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Комментировать: ${widget.targetTitle}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Напиши комментарий...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createComment,
              child: const Text('Опубликовать'),
            ),
          ],
        ),
      ),
    );
  }

  void _createComment() async {
    if (_controller.text.isNotEmpty) {
      // var profile = await FirestoreService.getProfile();
      // if (profile == null) return;

      // Comment newComment = Comment(
      //   id: DateTime.now().millisecondsSinceEpoch.toString(),
      //   authorId: profile.id,
      //   authorName: profile.name,
      //   content: _controller.text,
      //   createdAt: DateTime.now(),
      //   targetId: widget.targetId,
      //   targetType: widget.targetType,
      // );

      // await FirestoreService.addComment(newComment);

      Navigator.pop(context);
    }
  }
}
