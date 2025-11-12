import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/idea.dart';
import '../models/profile.dart';
import '../models/blog_post.dart';
import '../models/realization.dart';
import '../widgets/idea_card.dart';
import '../screens/profile_screen.dart';
import '../screens/blog_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _searchType = 'ideas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Поиск...',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _searchQuery = _searchController.text;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildSearchTypeChip('Идеи', 'ideas'),
                _buildSearchTypeChip('Авторы', 'authors'),
                _buildSearchTypeChip('Реализации', 'realizations'),
                _buildSearchTypeChip('Посты', 'posts'),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTypeChip(String label, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: _searchType == type,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _searchType = type;
            });
          }
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return const Center(child: Text('Введите запрос для поиска'));
    }

    switch (_searchType) {
      case 'ideas':
        return _buildIdeaResults();
      case 'authors':
        return _buildAuthorResults();
      case 'realizations':
        return _buildRealizationResults();
      case 'posts':
        return _buildPostResults();
      default:
        return const Center(child: Text('Нет результатов'));
    }
  }

  Widget _buildIdeaResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ideas')
          .where('content', isGreaterThanOrEqualTo: _searchQuery)
          .where('content', isLessThan: _searchQuery + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Нет результатов'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            Idea idea = Idea.fromJson(doc.data() as Map<String, dynamic>);
            return IdeaCard(idea: idea);
          },
        );
      },
    );
  }

  Widget _buildAuthorResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('profiles')
          .where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThan: _searchQuery + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Нет результатов'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            Profile profile = Profile.fromJson(doc.data() as Map<String, dynamic>);

            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(profile.name),
                subtitle: Text(profile.bio),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRealizationResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('realizations')
          .where('description', isGreaterThanOrEqualTo: _searchQuery)
          .where('description', isLessThan: _searchQuery + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Нет результатов'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            Realization realization = Realization.fromJson(doc.data() as Map<String, dynamic>);

            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(realization.thiefName),
                subtitle: Text(realization.description),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPostResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('blog_posts')
          .where('title', isGreaterThanOrEqualTo: _searchQuery)
          .where('title', isLessThan: _searchQuery + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Нет результатов'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            BlogPost post = BlogPost.fromJson(doc.data() as Map<String, dynamic>);

            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(post.title),
                subtitle: Text(post.content),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlogScreen(userId: post.authorId)),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
