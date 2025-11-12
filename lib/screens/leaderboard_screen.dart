import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/profile.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Таблица лидеров'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTab('Воры', 0),
                _buildTab('Реализаторы', 1),
                _buildTab('Уважаемые', 2),
                _buildTab('Блогеры', 3),
                _buildTab('Активные', 4),
                _buildTab('Перспективные', 5),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _buildLeaderboardContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ChoiceChip(
        label: Text(title),
        selected: _selectedIndex == index,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildLeaderboardContent() {
    String type;
    switch (_selectedIndex) {
      case 0:
        type = 'stolen';
        break;
      case 1:
        type = 'realized';
        break;
      case 2:
        type = 'respect';
        break;
      case 3:
        type = 'blog';
        break;
      case 4:
        type = 'activity';
        break;
      case 5:
        type = 'prospective';
        break;
      default:
        type = 'stolen';
    }

    return FutureBuilder<List<Profile>>(
      future: FirestoreService.getLeaderboard(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Нет данных'));
        }

        List<Profile> leaders = snapshot.data!;

        return ListView.builder(
          itemCount: leaders.length,
          itemBuilder: (context, index) {
            Profile profile = leaders[index];
            int score = 0;
            String label = '';

            switch (type) {
              case 'stolen':
                score = profile.stolenIdeasCount;
                label = 'украдено';
                break;
              case 'realized':
                score = profile.realizedCount;
                label = 'реализовано';
                break;
              case 'respect':
                score = profile.calculateRespectLevel();
                label = 'уважение';
                break;
              case 'blog':
                score = profile.blogPostIds.length; // Пример, если считаем по количеству постов
                label = 'постов';
                break;
              case 'activity':
                score = profile.totalFame;
                label = 'слава';
                break;
              case 'prospective':
                score = profile.calculateMonetizationPotential().toInt();
                label = 'потенциал';
                break;
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _getColorForRank(index),
                child: Text('${index + 1}'),
              ),
              title: Text(profile.name),
              subtitle: Text('$score $label'),
              trailing: Icon(
                _getIconForRank(index),
                color: _getColorForRank(index),
              ),
            );
          },
        );
      },
    );
  }

  Color _getColorForRank(int index) {
    switch (index) {
      case 0:
        return Colors.amber; // Золото
      case 1:
        return Colors.grey; // Серебро
      case 2:
        return const Color(0xFFCD7F32); // Бронза
      default:
        return Colors.grey.shade400; // Просто серый
    }
  }

  IconData _getIconForRank(int index) {
    switch (index) {
      case 0:
        return Icons.emoji_events;
      case 1:
        return Icons.verified;
      case 2:
        return Icons.tag_faces;
      default:
        return Icons.person;
    }
  }
}
