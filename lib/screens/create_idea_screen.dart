import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/firestore_service.dart';

class CreateIdeaScreen extends StatefulWidget {
  const CreateIdeaScreen({super.key});

  @override
  State<CreateIdeaScreen> createState() => _CreateIdeaScreenState();
}

class _CreateIdeaScreenState extends State<CreateIdeaScreen> {
  final TextEditingController _controller = TextEditingController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая идея'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Напиши идею...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Прикрепить фото'),
            ),
            if (_selectedImage != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 200,
                width: double.infinity,
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createIdea,
              child: const Text('Опубликовать'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _createIdea() async {
    if (_controller.text.isNotEmpty) {
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = _selectedImage!.path;
      }
      await FirestoreService.createIdea(_controller.text, imageUrl: imageUrl);
      Navigator.pop(context);
    }
  }
}
