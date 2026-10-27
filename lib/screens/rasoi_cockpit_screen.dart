import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rasoi_provider.dart';
import '../models/pantry_item.dart';
import '../theme/app_theme.dart';

class RasoiCockpitScreen extends StatefulWidget {
  const RasoiCockpitScreen({super.key});

  @override
  State<RasoiCockpitScreen> createState() => _RasoiCockpitScreenState();
}

class _RasoiCockpitScreenState extends State<RasoiCockpitScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Sabzi & Greens',
    'Dairy & Doodh',
    'Dal & Anaj',
    'Dry & Root',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RasoiProvider>();
    final items = provider.items.where((i) {
      final matchesSearch =
          i.hindiName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.englishName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat =
          _selectedCategory == 'All' || i.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    final urgentItems = provider.items
        .where((i) => i.daysRemaining <= 1)
        .toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        if (urgentItems.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.urgentLalBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.urgentLalText.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppTheme.urgentLalText,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${urgentItems.length} Cheezein Khatre Mein (Expires in 24h)!',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.urgentLalText,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        urgentItems.map((e) => e.hindiName).join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.urgentLalText.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        TextField(
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search sabzi, doodh, masale...',
            prefixIcon: const Icon(Icons.search, color: AppTheme.mutedText),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.borderGrey),
            ),
          ),
        ),
        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppTheme.saffronRed.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppTheme.saffronRed
                        : AppTheme.darkStone,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 12,
                  ),
                  onSelected: (val) => setState(() => _selectedCategory = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kitchen Inventory (${items.length})',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Total: ₹${items.fold(0.0, (s, i) => s + i.approxValueRupees).toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.mutedText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (items.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: AppTheme.mutedText,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No items found',
                    style: TextStyle(color: AppTheme.mutedText),
                  ),
                ],
              ),
            ),
          )
        else
          ...items.map((item) => _buildItemCard(context, provider, item)),
      ],
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    RasoiProvider provider,
    PantryItem item,
  ) {
    Color badgeBg;
    Color badgeText;
    String badgeLabel;

    if (item.daysRemaining <= 1) {
      badgeBg = AppTheme.urgentLalBg;
      badgeText = AppTheme.urgentLalText;
      badgeLabel = '${item.daysRemaining} din baaki (Lal)';
    } else if (item.daysRemaining <= 3) {
      badgeBg = AppTheme.soonPeelaBg;
      badgeText = AppTheme.soonPeelaText;
      badgeLabel = '${item.daysRemaining} din baaki (Peela)';
    } else {
      badgeBg = AppTheme.safeHaraBg;
      badgeText = AppTheme.safeHaraText;
      badgeLabel = '${item.daysRemaining} din surakshit (Hara)';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.hindiName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${item.englishName} • ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      color: badgeText,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.creamBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.tips_and_updates_outlined,
                    size: 16,
                    color: AppTheme.turmericAmber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.storageTip,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.darkStone,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Text(
                  'Value: ₹${item.approxValueRupees.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppTheme.forestEmerald,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => provider.moveToFreezer(item.id),
                  icon: const Icon(Icons.ac_unit, size: 14),
                  label: const Text('Freezer', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  tooltip: 'Log Wasted',
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppTheme.mutedText,
                  ),
                  onPressed: () => _confirmWasteDialog(context, provider, item),
                ),
                const SizedBox(width: 4),
                ElevatedButton.icon(
                  onPressed: () => provider.markEaten(item.id),
                  icon: const Icon(Icons.check, size: 14, color: Colors.white),
                  label: const Text(
                    'Khaa Liya',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.forestEmerald,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmWasteDialog(
    BuildContext context,
    RasoiProvider provider,
    PantryItem item,
  ) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Fek Diya: ${item.hindiName}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will log a loss of ₹${item.approxValueRupees.toStringAsFixed(0)} to your Bachat ledger.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (e.g. Fungus, Rotten, Sour smell)',
                border: OutlineInputBorder(),
              ),
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
              backgroundColor: AppTheme.urgentLalText,
            ),
            onPressed: () {
              provider.logWasted(item.id, reasonController.text);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Log Loss',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
