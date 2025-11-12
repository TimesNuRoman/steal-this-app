import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/blog_post.dart';

class BlogScreen extends StatelessWidget {
  final String userId;

  const BlogScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Блог'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<BlogPost>>(
        future: FirestoreService.getBlogPostsByUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет постов'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (snapshot.data![index].imageUrl != null)
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            snapshot.data![index].imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.data![index].title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        snapshot.data![index].content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'от ${snapshot.data![index].authorName}',
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
    );
  }
}
