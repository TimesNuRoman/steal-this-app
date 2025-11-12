import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ReportEarningScreen extends StatefulWidget {
  final String ideaId;

  const ReportEarningScreen({super.key, required this.ideaId});

  @override
  State<ReportEarningScreen> createState() => _ReportEarningScreenState();
}

class _ReportEarningScreenState extends State<ReportEarningScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _proofController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сообщить о заработке'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Ты реализовал идею и заработал?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Сколько заработал (рубли)?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _proofController,
              decoration: const InputDecoration(
                labelText: 'Доказательство (ссылка на чек/пост/продажу)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reportEarning,
              child: const Text('Отправить'),
            ),
          ],
        ),
      ),
    );
  }

  void _reportEarning() async {
    if (_amountController.text.isNotEmpty && _proofController.text.isNotEmpty) {
      double? amount = double.tryParse(_amountController.text);
      if (amount != null && amount > 0) {
        // await FirestoreService.recordEarning(
        //   widget.ideaId,
        //   amount,
        //   _proofController.text,
        // );
        // TODO: Показать сообщение об успехе
        Navigator.pop(context);
      }
    }
  }
}
