import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile.dart';
import '../models/idea.dart';
import '../models/realization.dart';
import '../models/blog_post.dart';
import '../models/comment.dart';
import '../models/tag.dart';
import '../models/story.dart';
import '../models/like.dart';
import 'auth_service.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _profilesCollection = 'profiles';
  static const String _ideasCollection = 'ideas';
  static const String _realizationsCollection = 'realizations';
  static const String _blogPostsCollection = 'blog_posts';
  static const String _commentsCollection = 'comments';
  static const String _tagsCollection = 'tags';
  static const String _storiesCollection = 'stories';
  static const String _likesCollection = 'likes';
  static const String _currencyTransactionsCollection = 'currency_transactions';
  static const String _boostsCollection = 'boosts';
  static const String _subscriptionsCollection = 'subscriptions';

  // --- Профиль ---
  static Future<void> createProfile(String name) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    Profile newProfile = Profile(
      id: user.uid,
      name: name,
      createdAt: DateTime.now(),
    );

    await _firestore.collection(_profilesCollection).doc(user.uid).set(newProfile.toJson());
  }

  static Future<Profile?> getProfile() async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return null;

    DocumentSnapshot doc = await _firestore.collection(_profilesCollection).doc(user.uid).get();
    if (!doc.exists) return null;

    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) return null;

    return Profile.fromJson(data);
  }

  static Future<Profile?> getProfileById(String userId) async {
    DocumentSnapshot doc = await _firestore.collection(_profilesCollection).doc(userId).get();
    if (!doc.exists) return null;

    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) return null;

    return Profile.fromJson(data);
  }

  static Future<void> updateProfile(Profile profile) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    await _firestore.collection(_profilesCollection).doc(user.uid).update(profile.toJson());
  }

  static Future<List<Profile>> getLeaderboard(String type) async {
    QuerySnapshot snapshot = await _firestore.collection(_profilesCollection).get();
    List<Profile> allProfiles = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        allProfiles.add(Profile.fromJson(data));
      }
    }

    switch (type) {
      case 'stolen':
        allProfiles.sort((a, b) => b.stolenIdeasCount.compareTo(a.stolenIdeasCount));
        break;
      case 'realized':
        allProfiles.sort((a, b) => b.realizedCount.compareTo(a.realizedCount));
        break;
      case 'respect':
        allProfiles.sort((a, b) => b.calculateRespectLevel().compareTo(a.calculateRespectLevel()));
        break;
      case 'activity':
        allProfiles.sort((a, b) => b.totalFame.compareTo(a.totalFame));
        break;
      case 'prospective':
        allProfiles.sort((a, b) => b.calculateMonetizationPotential().compareTo(a.calculateMonetizationPotential()));
        break;
      default:
        allProfiles.sort((a, b) => b.name.compareTo(a.name));
    }

    return allProfiles;
  }

  // --- Идеи ---
  static Future<List<Idea>> getTopIdeas() async {
    QuerySnapshot snapshot = await _firestore.collection(_ideasCollection).get();
    List<Idea> ideas = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        Idea idea = Idea.fromJson(data);

        DocumentSnapshot authorDoc = await _firestore.collection(_profilesCollection).doc(idea.authorId).get();
        if (authorDoc.exists) {
          Map<String, dynamic>? authorData = authorDoc.data() as Map<String, dynamic>?;
          if (authorData != null) {
            Profile authorProfile = Profile.fromJson(authorData);
            idea.boostFactor = authorProfile.calculateIdeaBoostFactor();
          }
        }

        ideas.add(idea);
      }
    }

    ideas.sort((a, b) => b.calculatePopularityScore().compareTo(a.calculatePopularityScore()));

    return ideas;
  }

  static Future<List<Idea>> getTopIdeasForSubscriptions() async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return [];

    DocumentSnapshot userDoc = await _firestore.collection(_profilesCollection).doc(user.uid).get();
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
    List<dynamic> subscriptions = userData?['subscriptions'] ?? [];

    if (subscriptions.isEmpty) {
      return [];
    }

    QuerySnapshot snapshot = await _firestore.collection(_ideasCollection).orderBy('createdAt', descending: true).limit(50).get();
    List<Idea> allIdeas = [];
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        Idea idea = Idea.fromJson(data);
        if (subscriptions.contains(idea.authorId)) {
          DocumentSnapshot authorDoc = await _firestore.collection(_profilesCollection).doc(idea.authorId).get();
          if (authorDoc.exists) {
            Map<String, dynamic>? authorData = authorDoc.data() as Map<String, dynamic>?;
            if (authorData != null) {
              Profile authorProfile = Profile.fromJson(authorData);
              idea.boostFactor = authorProfile.calculateIdeaBoostFactor();
            }
          }
          allIdeas.add(idea);
        }
      }
    }

    allIdeas.sort((a, b) => b.calculatePopularityScore().compareTo(a.calculatePopularityScore()));
    return allIdeas;
  }

  static Future<void> createIdea(String content, {String? imageUrl}) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    Profile? profile = await getProfile();
    if (profile == null) return;

    Idea newIdea = Idea(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      authorId: user.uid,
      authorName: profile.name,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      stealCount: 0,
      fameScore: 0,
      isFeatured: false,
      commentCount: 0,
      likeCount: 0,
    );

    await _firestore.collection(_ideasCollection).doc(newIdea.id).set(newIdea.toJson());

    // Начисляем валюту за создание идеи
    await addCurrencyToUser(15, 'create_idea');
  }

  static Future<void> stealIdea(String ideaId) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    Profile? profile = await getProfile();
    if (profile == null) return;

    DocumentReference ideaRef = _firestore.collection(_ideasCollection).doc(ideaId);
    DocumentReference userRef = _firestore.collection(_profilesCollection).doc(user.uid);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot ideaSnapshot = await transaction.get(ideaRef);
      if (!ideaSnapshot.exists) {
        throw Exception("Idea does not exist!");
      }

      Map<String, dynamic>? ideaData = ideaSnapshot.data() as Map<String, dynamic>?;
      if (ideaData == null) return;

      Idea idea = Idea.fromJson(ideaData);
      String ideaAuthorId = idea.authorId;

      idea.stealCount++;
      idea.fameScore++;

      transaction.update(ideaRef, idea.toJson());

      profile.stolenIdeasCount++;
      profile.totalFame++;
      transaction.update(userRef, profile.toJson());

      // Начисляем валюту за угон
      await addCurrencyToUser(10, 'steal_idea');
    });

    // Отправляем уведомление автору идеи
    await _sendNotificationToUser(
      targetUserId: ideaAuthorId,
      title: 'Твоя идея украдена!',
      body: '${profile!.name} украл твою идею: "${idea.content.substring(0, 20)}..."',
      type: 'idea_stolen',
    );
  }

  // --- Реализации ---
  static Future<void> createRealizationFromModel(Realization realization) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    await _firestore.collection(_realizationsCollection).doc(realization.id).set(realization.toJson());

    Profile? profile = await getProfile();
    if (profile != null) {
      profile.realizedCount++;
      profile.totalFame += 3;
      await _firestore.collection(_profilesCollection).doc(user.uid).update(profile.toJson());
    }
  }

  static Future<void> createRealization(String ideaId, String description) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    Profile? profile = await getProfile();
    if (profile == null) return;

    DocumentReference userRef = _firestore.collection(_profilesCollection).doc(user.uid);

    Realization newRealization = Realization(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ideaId: ideaId,
      thiefId: user.uid,
      thiefName: profile.name,
      description: description,
      createdAt: DateTime.now(),
      respectGained: 5,
      likes: 0,
    );

    await _firestore.collection(_realizationsCollection).doc(newRealization.id).set(newRealization.toJson());

    profile.realizedCount++;
    profile.totalFame += 3;
    await userRef.update(profile.toJson());
  }

  // --- Блог ---
  static Future<void> addBlogPost(BlogPost post) async {
    await _firestore.collection(_blogPostsCollection).doc(post.id).set(post.toJson());

    await _firestore.collection(_profilesCollection).doc(post.authorId).update({
      'blogPostIds': FieldValue.arrayUnion([post.id]),
      'totalFame': FieldValue.increment(1),
    });
  }

  static Future<List<BlogPost>> getBlogPostsByUser(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection(_blogPostsCollection)
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    List<BlogPost> posts = [];
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        posts.add(BlogPost.fromJson(data));
      }
    }

    return posts;
  }

  // --- Комментарии ---
  static Future<void> addComment(Comment comment) async {
    await _firestore.collection(_commentsCollection).doc(comment.id).set(comment.toJson());

    // Обновляем профиль автора комментария
    await _firestore.collection(_profilesCollection).doc(comment.authorId).update({
      'engagementScore': FieldValue.increment(5),
    });

    // Увеличиваем commentCount у цели (идеи/реализации)
    DocumentReference targetRef;
    if (comment.targetType == 'idea') {
      targetRef = _firestore.collection(_ideasCollection).doc(comment.targetId);
    } else if (comment.targetType == 'realization') {
      targetRef = _firestore.collection(_realizationsCollection).doc(comment.targetId);
    } else {
      return; // Неизвестный тип цели
    }

    await targetRef.update({'commentCount': FieldValue.increment(1)});
  }

  static Future<List<Comment>> getCommentsByTarget(String targetId, String targetType) async {
    QuerySnapshot snapshot = await _firestore
        .collection(_commentsCollection)
        .where('targetId', isEqualTo: targetId)
        .where('targetType', isEqualTo: targetType)
        .orderBy('createdAt', descending: true)
        .get();

    List<Comment> comments = [];
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        comments.add(Comment.fromJson(data));
      }
    }

    return comments;
  }

  // --- Теги ---
  static Future<List<Tag>> getAllTags() async {
    QuerySnapshot snapshot = await _firestore.collection(_tagsCollection).get();
    List<Tag> tags = [];
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        tags.add(Tag.fromJson(data));
      }
    }
    tags.sort((a, b) => b.popularity.compareTo(a.popularity));
    return tags;
  }

  static Future<void> incrementTagPopularity(String tagId) async {
    DocumentReference tagRef = _firestore.collection(_tagsCollection).doc(tagId);
    await tagRef.update({'popularity': FieldValue.increment(1)});
  }

  static Future<void> updateProfileTags(List<String> selectedTagIds) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    Profile? profile = await getProfile();
    if (profile == null) return;

    profile.tags = selectedTagIds;

    Map<String, int> newCategoryScores = {};
    for (String tagId in selectedTagIds) {
      DocumentSnapshot tagDoc = await _firestore.collection(_tagsCollection).doc(tagId).get();
      if (tagDoc.exists) {
        Map<String, dynamic>? tagData = tagDoc.data() as Map<String, dynamic>?;
        if (tagData != null) {
          String category = tagData['category'];
          newCategoryScores[category] = (newCategoryScores[category] ?? 0) + 10;
          await incrementTagPopularity(tagId);
        }
      }
    }
    profile.categoryScores = newCategoryScores;

    await _firestore.collection(_profilesCollection).doc(user.uid).update(profile.toJson());
  }

  // --- Валюта ---
  static Future<int> getUserCurrencyBalance() async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return 0;

    DocumentSnapshot doc = await _firestore.collection(_profilesCollection).doc(user.uid).get();
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) return 0;

    return data['currencyBalance'] ?? 0;
  }

  static Future<bool> purchaseItem(String action, int price) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return false;

    DocumentReference userRef = _firestore.collection(_profilesCollection).doc(user.uid);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot userSnapshot = await transaction.get(userRef);
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
        if (userData == null) throw Exception("User data not found");

        int currentBalance = userData['currencyBalance'] ?? 0;
        if (currentBalance < price) {
          throw Exception("Insufficient funds");
        }

        int newBalance = currentBalance - price;
        transaction.update(userRef, {'currencyBalance': newBalance});

        CurrencyTransaction transactionLog = CurrencyTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: user.uid,
          type: 'spent',
          action: action,
          amount: price,
          createdAt: DateTime.now(),
        );
        await _firestore.collection(_currencyTransactionsCollection).doc(transactionLog.id).set(transactionLog.toJson());

        if (action == 'boost_idea_24h') {
          // await _createBoost(user.uid, 'idea', targetIdeaId, 1.5, DateTime.now().add(Duration(hours: 24)));
        }
      });
      return true;
    } catch (e) {
      print("Purchase failed: $e");
      return false;
    }
  }

  static Future<void> addCurrencyToUser(int amount, String action) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    DocumentReference userRef = _firestore.collection(_profilesCollection).doc(user.uid);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userRef);
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
      if (userData == null) throw Exception("User data not found");

      int currentBalance = userData['currencyBalance'] ?? 0;
      int newBalance = currentBalance + amount;
      transaction.update(userRef, {'currencyBalance': newBalance});

      CurrencyTransaction transactionLog = CurrencyTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        type: 'earned',
        action: action,
        amount: amount,
        createdAt: DateTime.now(),
      );
      await _firestore.collection(_currencyTransactionsCollection).doc(transactionLog.id).set(transactionLog.toJson());
    });
  }

  // --- Лайки ---
  static Future<bool> likeTarget(String targetId, String targetType, int cost) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return false;

    Profile? profile = await getProfile();
    if (profile == null || profile.currencyBalance < cost) {
      return false;
    }

    String likeId = DateTime.now().millisecondsSinceEpoch.toString();
    Like newLike = Like(
      id: likeId,
      userId: user.uid,
      targetId: targetId,
      targetType: targetType,
      createdAt: DateTime.now(),
    );

    try {
      await _firestore.runTransaction((transaction) async {
        await transaction.set(_firestore.collection(_likesCollection).doc(likeId), newLike.toJson());

        await transaction.update(_firestore.collection(_profilesCollection).doc(user.uid), {
          'currencyBalance': FieldValue.increment(-cost),
        });

        String collectionName = targetType == 'idea' ? _ideasCollection :
                               targetType == 'comment' ? _commentsCollection :
                               targetType == 'realization' ? _realizationsCollection :
                               _blogPostsCollection;

        await transaction.update(_firestore.collection(collectionName).doc(targetId), {
          'likeCount': FieldValue.increment(1),
        });
      });

      return true;
    } catch (e) {
      print("Like failed: $e");
      return false;
    }
  }

  static Future<int> getLikeCount(String targetId, String targetType) async {
    QuerySnapshot snapshot = await _firestore
        .collection(_likesCollection)
        .where('targetId', isEqualTo: targetId)
        .where('targetType', isEqualTo: targetType)
        .get();

    return snapshot.size;
  }

  static Future<bool> hasUserLiked(String targetId, String targetType) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return false;

    QuerySnapshot snapshot = await _firestore
        .collection(_likesCollection)
        .where('targetId', isEqualTo: targetId)
        .where('targetType', isEqualTo: targetType)
        .where('userId', isEqualTo: user.uid)
        .get();

    return snapshot.size > 0;
  }

  // --- Подписки ---
  static Future<bool> subscribeToUser(String targetUserId) async {
    User? user = AuthService.getCurrentUser();
    if (user == null || user.uid == targetUserId) return false;

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference userRef = _firestore.collection(_profilesCollection).doc(user.uid);
        DocumentReference targetUserRef = _firestore.collection(_profilesCollection).doc(targetUserId);

        DocumentSnapshot userSnapshot = await transaction.get(userRef);
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
        if (userData == null) throw Exception("User data not found");

        List<dynamic> currentSubs = userData['subscriptions'] ?? [];
        if (currentSubs.contains(targetUserId)) {
          return;
        }

        transaction.update(userRef, {'subscriptions': FieldValue.arrayUnion([targetUserId])});
      });
      return true;
    } catch (e) {
      print("Subscribe failed: $e");
      return false;
    }
  }

  static Future<bool> unsubscribeFromUser(String targetUserId) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return false;

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference userRef = _firestore.collection(_profilesCollection).doc(user.uid);
        transaction.update(userRef, {'subscriptions': FieldValue.arrayRemove([targetUserId])});
      });
      return true;
    } catch (e) {
      print("Unsubscribe failed: $e");
      return false;
    }
  }

  // --- Истории ---
  static Future<void> createStory(String text, {String? imageUrl}) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    Profile? profile = await getProfile();
    if (profile == null) return;

    Story newStory = Story(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: user.uid,
      authorName: profile.name,
      imageUrl: imageUrl,
      text: text,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    await _firestore.collection(_storiesCollection).doc(newStory.id).set(newStory.toJson());
  }

  static Future<List<Story>> getStoriesForSubscriptions() async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return [];

    DocumentSnapshot userDoc = await _firestore.collection(_profilesCollection).doc(user.uid).get();
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
    List<dynamic> subscriptions = userData?['subscriptions'] ?? [];
    subscriptions.add(user.uid);

    QuerySnapshot snapshot = await _firestore
        .collection(_storiesCollection)
        .where('authorId', whereIn: subscriptions.cast<String>())
        .where('expiresAt', isGreaterThan: FieldValue.serverTimestamp())
        .orderBy('createdAt', descending: true)
        .get();

    List<Story> stories = [];
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        stories.add(Story.fromJson(data));
      }
    }

    stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return stories;
  }

  // --- Вспомогательный метод для уведомлений ---
  static Future<void> _sendNotificationToUser({required String targetUserId, required String title, required String body, required String type}) async {
    RemoteMessage mockMessage = RemoteMessage(
       {
        'targetUserId': targetUserId,
        'type': type,
      },
      notification: RemoteNotification(
        title: title,
        body: body,
      ),
    );
    await NotificationsService._saveNotificationToFirestore(mockMessage);
  }
}
