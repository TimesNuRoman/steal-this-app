import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<Story> stories;

  const StoryViewerScreen({super.key, required this.stories});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.stories.isEmpty) {
      return Scaffold(
        body: const Center(child: Text('Нет историй')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          child: const Icon(Icons.close),
        ),
      );
    }

    Story currentStory = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: currentStory.imageUrl != null
                ? Image.network(currentStory.imageUrl!, fit: BoxFit.contain)
                : Container(color: Colors.grey, child: const Icon(Icons.image, color: Colors.white)),
          ),
          if (currentStory.text != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Text(
                  currentStory.text!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              children: widget.stories.asMap().entries.map((entry) {
                int index = entry.key;
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: index < _currentIndex
                        ? Colors.white
                        : index == _currentIndex
                            ? Colors.red
                            : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: InkWell(
              onTap: () {
                if (_currentIndex > 0) {
                  setState(() {
                    _currentIndex--;
                  });
                }
              },
              child: const SizedBox(width: 100, height: double.infinity),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                if (_currentIndex < widget.stories.length - 1) {
                  setState(() {
                    _currentIndex++;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              child: const SizedBox(width: 100, height: double.infinity),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.black54,
        child: const Icon(Icons.close, color: Colors.white),
      ),
    );
  }
}
