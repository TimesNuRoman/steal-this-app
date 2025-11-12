import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/profile.dart';
import 'blog_screen.dart';
import 'edit_profile_screen.dart';
import 'shop_screen.dart';
import 'notifications_screen.dart';
import 'leaderboard_screen.dart';
import '../services/theme_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.shop),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Светлая'),
                onTap: () => _setTheme(context, ThemeMode.light),
              ),
              PopupMenuItem(
                child: const Text('Тёмная'),
                onTap: () => _setTheme(context, ThemeMode.dark),
              ),
              PopupMenuItem(
                child: const Text('Системная'),
                onTap: () => _setTheme(context, ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<Profile>(
        future: FirestoreService.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Center(child: Text('Ошибка'));

          Profile user = snapshot.data!;

          return Column(
            children: [
              ListTile(
                title: Text(user.name),
                subtitle: Text(user.bio),
              ),
              const Divider(),
              ListTile(
                title: const Text('Украдено идей'),
                trailing: Text('${user.stolenIdeasCount}'),
              ),
              ListTile(
                title: const Text('Реализовано'),
                trailing: Text('${user.realizedCount}'),
              ),
              ListTile(
                title: const Text('Уважение'),
                trailing: Text('${user.respectLevel}'),
              ),
              ListTile(
                title: const Text('Слава'),
                trailing: Text('${user.totalFame}'),
              ),
              ListTile(
                title: const Text('Заработок для других'),
                trailing: Text('${user.totalEarningsFromOthers.toStringAsFixed(2)} RUB'),
              ),
              ListTile(
                title: const Text('Уровень влияния'),
                trailing: Text('${user.calculateInfluenceLevel()}'),
              ),
              ListTile(
                title: const Text('Блог'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlogScreen(userId: user.id)),
                  );
                },
              ),
              ListTile(
                title: const Text('Редактировать профиль'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );
                },
              ),
              if (user.telegram != null ||
                  user.whatsapp != null ||
                  user.discord != null ||
                  user.email != null)
                ListTile(
                  title: const Text('Связаться'),
                  subtitle: Text('Выберите способ связи'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showContactOptions(context, user);
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  void _showContactOptions(BuildContext context, Profile profile) {
    List<Widget> options = [];

    if (profile.telegram != null) {
      options.add(ListTile(
        leading: const Icon(Icons.telegram),
        title: const Text('Telegram'),
        onTap: () => _launchURL('https://t.me/${profile.telegram}'),
      ));
    }

    if (profile.whatsapp != null) {
      options.add(ListTile(
        leading: const Icon(Icons.whatsapp),
        title: const Text('WhatsApp'),
        onTap: () => _launchURL('https://wa.me/${profile.whatsapp}'),
      ));
    }

    if (profile.discord != null) {
      options.add(ListTile(
        leading: const Icon(Icons.chat),
        title: const Text('Discord'),
        onTap: () => _launchURL('https://discord.gg/${profile.discord}'),
      ));
    }

    if (profile.email != null) {
      options.add(ListTile(
        leading: const Icon(Icons.email),
        title: const Text('Email'),
        onTap: () => _launchURL('mailto:${profile.email}'),
      ));
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите способ связи'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  void _setTheme(BuildContext context, ThemeMode mode) {
    Provider.of<ThemeService>(context, listen: false).setTheme(mode);
  }
}
