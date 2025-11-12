import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/realization.dart';
import '../services/firestore_service.dart';
import '../models/profile.dart';

class RealizationCard extends StatelessWidget {
  final Realization realization;

  const RealizationCard({super.key, required this.realization});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (realization.imageUrl != null)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(realization.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (realization.imageUrl != null) const SizedBox(height: 12),
            Text(
              realization.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'от ${realization.thiefName}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (realization.isForSale) ...[
              Row(
                children: [
                  Text(
                    '${realization.price?.toStringAsFixed(2)} ${realization.currency}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _launchOrder(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Заказать'),
                  ),
                ],
              ),
            ],
            Row(
              children: [
                Text(
                  '${realization.likes} лайков',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchOrder(BuildContext context) async {
    Profile? authorProfile = await FirestoreService.getProfileById(realization.thiefId);
    if (authorProfile == null) {
      // TODO: Show error
      return;
    }

    String message = 'Привет! Я хочу заказать: "${realization.description}". Цена: ${realization.price} ${realization.currency}.';

    if (realization.orderLink != null) {
        if (await canLaunch(realization.orderLink!)) {
            await launch(realization.orderLink!);
            return;
        }
    }

    if (authorProfile.telegram != null) {
      String url = 'https://t.me/${authorProfile.telegram}?text=${Uri.encodeComponent(message)}';
      if (await canLaunch(url)) {
        await launch(url);
        return;
      }
    }
    if (authorProfile.whatsapp != null) {
      String url = 'https://wa.me/${authorProfile.whatsapp}?text=${Uri.encodeComponent(message)}';
      if (await canLaunch(url)) {
        await launch(url);
        return;
      }
    }
    if (authorProfile.email != null) {
      String url = 'mailto:${authorProfile.email}?subject=Заказ&body=${Uri.encodeComponent(message)}';
      if (await canLaunch(url)) {
        await launch(url);
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Не удалось связаться с автором')),
    );
  }
}
