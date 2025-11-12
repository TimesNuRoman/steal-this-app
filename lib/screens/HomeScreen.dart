import 'package:flutter/material.dart';
import 'package:steal_this_app/services/ApiService.dart';
import 'package:steal_this_app/widgets/IdeaCard.dart';
import 'CreateIdeaScreen.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Укради Это'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Idea>>(
        future: ApiService.fetchTopIdeas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Нет идей'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return IdeaCard(idea: snapshot.data![index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateIdeaScreen()),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }
}
