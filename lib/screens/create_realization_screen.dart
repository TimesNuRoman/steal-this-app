import 'package:flutter/material.dart';
import '../models/idea.dart';
import '../models/realization.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class CreateRealizationScreen extends StatefulWidget {
  final Idea idea;

  const CreateRealizationScreen({super.key, required this.idea});

  @override
  State<CreateRealizationScreen> createState() => _CreateRealizationScreenState();
}

class _CreateRealizationScreenState extends State<CreateRealizationScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isForSale = false;
  final TextEditingController _priceController = TextEditingController();
  String _currency = 'RUB';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сделай из этого что-то'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Ты украл идею: "${widget.idea.content}"'),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Опиши, что ты сделал',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Это на продажу'),
              value: _isForSale,
              onChanged: (value) {
                setState(() {
                  _isForSale = value;
                });
              },
            ),
            if (_isForSale) ...[
              TextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Цена',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _currency,
                decoration: const InputDecoration(
                  labelText: 'Валюта',
                  border: OutlineInputBorder(),
                ),
                items: ['RUB', 'USD', 'EUR'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _currency = newValue!;
                  });
                },
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: _createRealization,
              child: const Text('Опубликовать'),
            ),
          ],
        ),
      ),
    );
  }

  void _createRealization() async {
    if (_descriptionController.text.isNotEmpty) {
      double? price;
      if (_isForSale && _priceController.text.isNotEmpty) {
        price = double.tryParse(_priceController.text);
        if (price == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Неверный формат цены')),
          );
          return;
        }
      }

      User? user = AuthService.getCurrentUser();
      if (user == null) return;

      Profile? profile = await FirestoreService.getProfile();
      if (profile == null) return;

      Realization newRealization = Realization(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ideaId: widget.idea.id,
        thiefId: user.uid,
        thiefName: profile.name,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        isForSale: _isForSale,
        price: price,
        currency: _currency,
      );

      await FirestoreService.createRealizationFromModel(newRealization);

      Navigator.pop(context);
    }
  }
}
