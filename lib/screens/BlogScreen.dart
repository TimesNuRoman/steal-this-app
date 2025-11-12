import 'package:flutter/material.dart';
import 'package:steal_this_app/models/BlogPost.dart';
import 'package:steal_this_app/services/ApiService.dart';

class BlogScreen extends StatelessWidget {
  final String userId;

  const BlogScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Блог'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<BlogPost>>(
        future: ApiService.fetchBlogPostsByUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return Center(child: Text('Нет постов'));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].title),
                subtitle: Text(snapshot.data![index].content.substring(0, 100)),
                onTap: () {
                  // Открыть пост
                },
              );
            },
          );
        },
      ),
    );
  }
}
