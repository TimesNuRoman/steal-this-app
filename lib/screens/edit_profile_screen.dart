import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/profile.dart';
import '../models/tag.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _telegramController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _discordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Tag> allTags = [];
  List<String> selectedTagIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileAndTags();
  }

  void _loadProfileAndTags() async {
    setState(() { isLoading = true; });

    List<Tag> tags = await FirestoreService.getAllTags();
    Profile? profile = await FirestoreService.getProfile();

    if (profile != null) {
      _nameController.text = profile.name;
      _bioController.text = profile.bio;
      _telegramController.text = profile.telegram ?? '';
      _whatsappController.text = profile.whatsapp ?? '';
      _discordController.text = profile.discord ?? '';
      _emailController.text = profile.email ?? '';
      selectedTagIds = List.from(profile.tags);
    }

    setState(() {
      allTags = tags;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Имя', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Био', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Telegram (@username)', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _telegramController,
                decoration: const InputDecoration(
                  hintText: '@yourname',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('WhatsApp (+7...)', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _whatsappController,
                decoration: const InputDecoration(
                  hintText: '+79991234567',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Discord (username#1234)', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _discordController,
                decoration: const InputDecoration(
                  hintText: 'username#1234',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Выбери свои направления:', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: allTags.length,
                  itemBuilder: (context, index) {
                    Tag tag = allTags[index];
                    bool isSelected = selectedTagIds.contains(tag.id);
                    return CheckboxListTile(
                      title: Text(tag.name),
                      subtitle: Text(tag.category),
                      value: isSelected,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            selectedTagIds.add(tag.id);
                          } else {
                            selectedTagIds.remove(tag.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите имя')),
      );
      return;
    }

    Profile? profile = await FirestoreService.getProfile();
    if (profile == null) return;

    profile.name = _nameController.text;
    profile.bio = _bioController.text;
    profile.telegram = _telegramController.text.trim().isEmpty ? null : _telegramController.text;
    profile.whatsapp = _whatsappController.text.trim().isEmpty ? null : _whatsappController.text;
    profile.discord = _discordController.text.trim().isEmpty ? null : _discordController.text;
    profile.email = _emailController.text.trim().isEmpty ? null : _emailController.text;
    profile.tags = selectedTagIds;

    await FirestoreService.updateProfile(profile);
    await FirestoreService.updateProfileTags(selectedTagIds);

    Navigator.pop(context);
  }
}
