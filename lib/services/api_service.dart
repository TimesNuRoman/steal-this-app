import '../models/idea.dart';
import '../models/profile.dart';
import '../models/realization.dart';
import '../models/blog_post.dart';
import '../services/firestore_service.dart';

class ApiService {
  static Future<List<Idea>> fetchTopIdeas() async {
    return await FirestoreService.getTopIdeas();
  }

  static Future<void> createIdea(String content, {String? imageUrl}) async {
    await FirestoreService.createIdea(content, imageUrl: imageUrl);
  }

  static Future<void> stealIdea(String ideaId) async {
    await FirestoreService.stealIdea(ideaId);
  }

  static Future<void> createRealization(String ideaId, String description) async {
    await FirestoreService.createRealization(ideaId, description);
  }

  static Future<Profile> fetchCurrentUserProfile() async {
    Profile? profile = await FirestoreService.getProfile();
    if (profile == null) throw Exception('No profile found');
    return profile;
  }
}
