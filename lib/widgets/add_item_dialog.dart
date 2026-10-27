import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rasoi_provider.dart';
import '../models/pantry_item.dart';
import '../theme/app_theme.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _hindiNameCtrl = TextEditingController();
  final _engNameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '500 g');
  final _priceCtrl = TextEditingController(text: '40');
  String _category = 'Sabzi & Greens';
  final StorageZone _zone = StorageZone.crisperDrawer;
  int _daysRemaining = 4;

  final List<String> _categories = [
    'Sabzi & Greens',
    'Dairy & Doodh',
    'Dal & Anaj',
    'Dry & Root',
    'Masale & Chutney',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Item to Rasoi Tokri',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _hindiNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Hindi Name (e.g. Bhindi, Palak, Paneer)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _engNameCtrl,
              decoration: const InputDecoration(
                labelText: 'English Name (e.g. Ladyfinger, Spinach)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _qtyCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Quantity (e.g. 500 g, 1 Bunch)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _priceCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Est. Value (₹)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shelf-Life: $_daysRemaining Days baaki',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _daysRemaining.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  activeColor: AppTheme.saffronRed,
                  onChanged: (val) =>
                      setState(() => _daysRemaining = val.round()),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.saffronRed,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_hindiNameCtrl.text.isNotEmpty) {
                    final provider = context.read<RasoiProvider>();
                    final item = PantryItem(
                      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                      hindiName: _hindiNameCtrl.text,
                      englishName: _engNameCtrl.text.isEmpty
                          ? _hindiNameCtrl.text
                          : _engNameCtrl.text,
                      category: _category,
                      quantity: _qtyCtrl.text,
                      storageZone: _zone,
                      daysRemaining: _daysRemaining,
                      urgency: _daysRemaining <= 1
                          ? UrgencyLevel.urgentToday
                          : (_daysRemaining <= 3
                                ? UrgencyLevel.useSoon
                                : UrgencyLevel.freshSafe),
                      approxValueRupees:
                          double.tryParse(_priceCtrl.text) ?? 40.0,
                      storageTip:
                          'Store in dry airy container or crisper section.',
                      rescueIdea: 'Fresh sabzi or dal tadka',
                      dateAdded: DateTime.now(),
                    );
                    provider.addItem(item);
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add to Kitchen Inventory',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
