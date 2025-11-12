import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<_ShopItem> _items = [
    _ShopItem('Буст идеи (24ч)', 50, 'boost_idea_24h'),
    _ShopItem('Буст реализации (24ч)', 50, 'boost_realization_24h'),
    _ShopItem('Подарок (+10 уважения)', 100, 'gift_respect'),
    _ShopItem('Скрытие комментария', 30, 'hide_comment'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Магазин'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<int>(
        future: FirestoreService.getUserCurrencyBalance(),
        builder: (context, snapshot) {
          int balance = snapshot.data ?? 0;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Ваш баланс: $balance Угонов',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    var item = _items[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('${item.price} Угонов'),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            bool success = await FirestoreService.purchaseItem(item.action, item.price);
                            if (success) {
                              // TODO: Показать сообщение об успехе
                              // TODO: Выполнить действие (например, буст)
                              setState(() {});
                            } else {
                              // TODO: Показать сообщение об ошибке (не хватает валюты)
                            }
                          },
                          child: const Text('Купить'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ShopItem {
  final String name;
  final int price;
  final String action;

  _ShopItem(this.name, this.price, this.action);
}
