import 'package:flutter/material.dart';
import '../models/idea.dart';
import '../screens/idea_detail_screen.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class IdeaCard extends StatefulWidget {
  final Idea idea;

  const IdeaCard({super.key, required this.idea});

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IdeaDetailScreen(idea: widget.idea)),
                );
              },
              onDoubleTap: () async {
                await _animationController.forward();
                await Future.delayed(const Duration(milliseconds: 100));
                await _animationController.reverse();

                bool success = await FirestoreService.likeTarget(widget.idea.id, 'idea', 5);
                if (success) {
                  setState(() {
                    widget.idea.likeCount++;
                  });
                } else {
                  // TODO: Show message about insufficient currency
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.idea.imageUrl != null)
                      Container(
                        width: double.infinity,
                        height: 200,
                        child: Image.file(
                          Container(color: Colors.grey, child: const Text('Image Placeholder')),
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (widget.idea.imageUrl != null) const SizedBox(height: 12),
                    Text(
                      widget.idea.content,
                      style: const TextStyle(fontSize: 19, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'от ${widget.idea.authorName}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(
                          '${widget.idea.stealCount} угонов',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        FutureBuilder<bool>(
                          future: FirestoreService.hasUserLiked(widget.idea.id, 'idea'),
                          builder: (context, snapshot) {
                            bool isLiked = snapshot.data ?? false;
                            return IconButton(
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : null,
                              ),
                              onPressed: () async {
                                bool success = await FirestoreService.likeTarget(widget.idea.id, 'idea', 5);
                                if (success) {
                                  setState(() {
                                    widget.idea.likeCount++;
                                  });
                                  await _animationController.forward();
                                  await Future.delayed(const Duration(milliseconds: 100));
                                  await _animationController.reverse();
                                } else {
                                  // TODO: Show message about insufficient currency
                                }
                              },
                            );
                          },
                        ),
                        Text('${widget.idea.likeCount}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
