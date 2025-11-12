import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/blog_post.dart';

class CreateBlogPostScreen extends StatefulWidget {
  final String relatedIdeaId;

  const CreateBlogPostScreen({super.key, required this.relatedIdeaId});

  @override
  State<CreateBlogPostScreen> createState() => _CreateBlogPostScreenState();
}

class _CreateBlogPostScreenState extends State<CreateBlogPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый пост'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Заголовок',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Расскажи, как ты реализовал идею...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createPost,
              child: const Text('Опубликовать'),
            ),
          ],
        ),
      ),
    );
  }

  void _createPost() async {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      // var profile = await FirestoreService.getProfile();
      // if (profile == null) return;

      // BlogPost newPost = BlogPost(
      //   id: DateTime.now().millisecondsSinceEpoch.toString(),
      //   authorId: profile.id,
      //   authorName: profile.name,
      //   title: _titleController.text,
      //   content: _contentController.text,
      //   createdAt: DateTime.now(),
      //   relatedIdeaIds: [widget.relatedIdeaId],
      // );

      // await FirestoreService.addBlogPost(newPost);

      Navigator.pop(context);
    }
  }
}
