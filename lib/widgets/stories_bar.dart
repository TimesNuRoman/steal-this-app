import 'package:flutter/material.dart';
import '../models/story.dart';
import '../screens/story_viewer_screen.dart';

class StoriesBar extends StatelessWidget {
  final List<Story> stories;

  const StoriesBar({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) {
      return const SizedBox.shrink();
    }

    Map<String, List<Story>> storiesByAuthor = {};
    for (var story in stories) {
      storiesByAuthor.putIfAbsent(story.authorId, () => []).add(story);
    }

    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: storiesByAuthor.entries.map((entry) {
          List<Story> userStories = entry.value;
          Story firstStory = userStories.first;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryViewerScreen(stories: userStories),
                  ),
                );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: firstStory.imageUrl != null
                      ? Image.network(firstStory.imageUrl!, fit: BoxFit.cover)
                      : Container(color: Colors.grey, child: const Icon(Icons.image)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
