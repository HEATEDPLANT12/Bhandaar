import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rasoi_provider.dart';
import '../models/pantry_item.dart';
import '../theme/app_theme.dart';

class MandiListScreen extends StatelessWidget {
  const MandiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RasoiProvider>();
    final checkedCount = provider.mandiList.where((i) => i.isChecked).length;
    final totalEstimated = provider.mandiList.fold(
      0.0,
      (s, i) => s + i.estimatedPrice,
    );

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mandi Checklist',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$checkedCount of ${provider.mandiList.length} items purchased',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.mutedText,
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${totalEstimated.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkStone,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (checkedCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.forestEmerald,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.move_to_inbox, color: Colors.white),
                label: Text(
                  'Transfer $checkedCount Items into Rasoi Tokri',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  provider.transferCheckedMandiToPantry();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Items added to Kitchen Pantry with fresh shelf life!',
                      ),
                      backgroundColor: AppTheme.forestEmerald,
                    ),
                  );
                },
              ),
            ),

          ...provider.mandiList.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                value: item.isChecked,
                activeColor: AppTheme.forestEmerald,
                onChanged: (_) => provider.toggleMandiItem(item.id),
                title: Text(
                  item.hindiName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: item.isChecked
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Text('${item.englishName} • ${item.quantity}'),
                secondary: Text(
                  '₹${item.estimatedPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mutedText,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.saffronRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Mandi Item',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => _showAddMandiDialog(context, provider),
      ),
    );
  }

  void _showAddMandiDialog(BuildContext context, RasoiProvider provider) {
    final hindiCtrl = TextEditingController();
    final engCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Item to Mandi List'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: hindiCtrl,
              decoration: const InputDecoration(
                labelText: 'Hindi Name (e.g. Nimbu)',
              ),
            ),
            TextField(
              controller: engCtrl,
              decoration: const InputDecoration(
                labelText: 'English Name (e.g. Lemons)',
              ),
            ),
            TextField(
              controller: qtyCtrl,
              decoration: const InputDecoration(
                labelText: 'Quantity (e.g. 500 g, 6 pcs)',
              ),
            ),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(
                labelText: 'Approx Price ₹ (e.g. 40)',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.saffronRed,
            ),
            onPressed: () {
              if (hindiCtrl.text.isNotEmpty) {
                provider.addMandiItem(
                  MandiItem(
                    id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                    hindiName: hindiCtrl.text,
                    englishName: engCtrl.text.isEmpty
                        ? hindiCtrl.text
                        : engCtrl.text,
                    category: 'Sabzi & Greens',
                    quantity: qtyCtrl.text.isEmpty ? '1 kg' : qtyCtrl.text,
                    estimatedPrice: double.tryParse(priceCtrl.text) ?? 30.0,
                  ),
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
