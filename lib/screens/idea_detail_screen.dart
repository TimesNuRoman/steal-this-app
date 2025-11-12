import 'package:flutter/material.dart';
import '../models/idea.dart';
import '../models/comment.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'create_comment_screen.dart';

class IdeaDetailScreen extends StatelessWidget {
  final Idea idea;

  const IdeaDetailScreen({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали идеи'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (idea.authorId == AuthService.getCurrentUser()?.uid)
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Редактировать'),
                  onTap: () => _editIdea(context),
                ),
                PopupMenuItem(
                  child: const Text('Удалить'),
                  onTap: () => _deleteIdea(context),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (idea.imageUrl != null)
                    Container(
                      width: double.infinity,
                      height: 200,
                      child: Image.network(
                        idea.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (idea.imageUrl != null) const SizedBox(height: 12),
                  Text(
                    idea.content,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'от ${idea.authorName}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${idea.stealCount} угонов'),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateCommentScreen(
                                targetId: idea.id,
                                targetType: 'idea',
                                targetTitle: idea.content,
                              ),
                            ),
                          );
                        },
                        child: const Text('Комментировать'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Комментарии',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: FirestoreService.getCommentsByTarget(idea.id, 'idea'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нет комментариев'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Comment comment = snapshot.data![index];
                    bool isAuthor = comment.authorId == AuthService.getCurrentUser()?.uid;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.authorName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (isAuthor)
                                  const Spacer(),
                                if (isAuthor)
                                  PopupMenuButton(
                                    icon: const Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: const Text('Редактировать'),
                                        onTap: () => _editComment(context, comment),
                                      ),
                                      PopupMenuItem(
                                        child: const Text('Удалить'),
                                        onTap: () => _deleteComment(context, comment.id),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(comment.content),
                            const SizedBox(height: 4),
                            Text(
                              comment.createdAt.toString().split('.').first,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editIdea(BuildContext context) {
    // TODO: Перейти на экран редактирования идеи
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Редактирование идеи')));
  }

  Future<void> _deleteIdea(BuildContext context) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить идею?'),
        content: Text('Вы уверены, что хотите удалить идею: "${idea.content}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // await FirestoreService.deleteIdea(idea.id);
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Идея удалена (заглушка)')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    }
  }

  void _editComment(BuildContext context, Comment comment) {
    // TODO: Перейти на экран редактирования комментария
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Редактирование комментария')));
  }

  Future<void> _deleteComment(BuildContext context, String commentId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить комментарий?'),
        content: const Text('Вы уверены, что хотите удалить этот комментарий?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // await FirestoreService.deleteComment(commentId);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Комментарий удалён (заглушка)')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    }
  }
}
