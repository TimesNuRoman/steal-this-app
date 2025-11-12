import 'package:flutter/material.dart';
import 'package:steal_this_app/models/Thief.dart';
import 'package:steal_this_app/services/ApiService.dart';
import 'BlogScreen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Thief>(
        future: ApiService.fetchCurrentUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return Center(child: Text('Ошибка'));

          Thief user = snapshot.data!;

          return Column(
            children: [
              ListTile(
                title: Text(user.name),
                subtitle: Text(user.bio),
              ),
              ListTile(
                title: Text('Украдено идей'),
                trailing: Text('${user.stolenIdeasCount}'),
              ),
              ListTile(
                title: Text('Реализовано'),
                trailing: Text('${user.realizedCount}'),
              ),
              ListTile(
                title: Text('Уважение'),
                trailing: Text('${user.respectLevel}'),
              ),
              ListTile(
                title: Text('Слава'),
                trailing: Text('${user.totalFame}'),
              ),
              ListTile(
                title: Text('Блог'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlogScreen(userId: user.id)),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
