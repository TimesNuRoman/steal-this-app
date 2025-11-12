import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class NotificationsService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onTokenRefresh.listen((token) {
      print("New FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');

    await _localNotifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
    );

    await _saveNotificationToFirestore(message);
  }

  static Future<void> _saveNotificationToFirestore(RemoteMessage message) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    String? targetUserId = message.data['targetUserId'];
    String? type = message.data['type'];
    String? title = message.notification?.title;
    String? body = message.notification?.body;

    if (targetUserId == user.uid && title != null && body != null && type != null) {
      Map<String, dynamic> notificationData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'userId': user.uid,
        'title': title,
        'body': body,
        'type': type,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('notifications').add(notificationData);
    }
  }

  static Stream<QuerySnapshot> getNotificationsStream() {
    User? user = AuthService.getCurrentUser();
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> markAsRead(String notificationId) async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    await FirebaseFirestore.instance.collection('notifications').doc(notificationId).update({'read': true});
  }

  static Future<void> markAllAsRead() async {
    User? user = AuthService.getCurrentUser();
    if (user == null) return;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: user.uid)
        .where('read', isEqualTo: false)
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }
}
