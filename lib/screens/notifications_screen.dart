import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/notifications_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.markunread_mailbox),
            onPressed: NotificationsService.markAllAsRead,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: NotificationsService.getNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Нет уведомлений'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              bool isRead = data['read'] ?? false;
              String title = data['title'] ?? 'Без заголовка';
              String body = data['body'] ?? 'Без содержания';
              DateTime? createdAt = (data['createdAt'] as Timestamp?)?.toDate();

              return Card(
                color: isRead ? Colors.white : Colors.grey.shade200,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(body),
                  trailing: Text(createdAt?.toString().split('.').first ?? ''),
                  onTap: () {
                    NotificationsService.markAsRead(doc.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
