import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rasoi_provider.dart';
import '../theme/app_theme.dart';
import 'rasoi_cockpit_screen.dart';
import 'rescue_chef_screen.dart';
import 'bachat_ledger_screen.dart';
import 'mandi_list_screen.dart';
import 'nuskhe_screen.dart';
import '../widgets/add_item_dialog.dart';
import '../widgets/receipt_scan_dialog.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RasoiCockpitScreen(),
    RescueChefScreen(),
    BachatLedgerScreen(),
    MandiListScreen(),
    NuskheScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final urgentCount = context.select<RasoiProvider, int>(
      (p) => p.urgentCount,
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.saffronRed.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.kitchen,
                color: AppTheme.saffronRed,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bhandaar भंडार',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Desi Zero-Waste Cockpit',
                  style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Scan Mandi Receipt / Bill',
            icon: const Icon(
              Icons.document_scanner_outlined,
              color: AppTheme.darkStone,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const ReceiptScanDialog(),
              );
            },
          ),
          IconButton(
            tooltip: 'Add Sabzi / Grocery',
            icon: const Icon(
              Icons.add_circle,
              color: AppTheme.saffronRed,
              size: 28,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AddItemDialog(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: AppTheme.saffronRed.withValues(alpha: 0.14),
        backgroundColor: Colors.white,
        destinations: [
          NavigationDestination(
            icon: Badge(
              isLabelVisible: urgentCount > 0,
              label: Text('$urgentCount'),
              backgroundColor: AppTheme.urgentLalText,
              child: const Icon(Icons.inventory_2_outlined),
            ),
            selectedIcon: const Icon(
              Icons.inventory_2,
              color: AppTheme.saffronRed,
            ),
            label: 'Rasoi',
          ),
          const NavigationDestination(
            icon: Icon(Icons.soup_kitchen_outlined),
            selectedIcon: Icon(Icons.soup_kitchen, color: AppTheme.saffronRed),
            label: 'Rescue Chef',
          ),
          const NavigationDestination(
            icon: Icon(Icons.currency_rupee_outlined),
            selectedIcon: Icon(
              Icons.currency_rupee,
              color: AppTheme.saffronRed,
            ),
            label: 'Bachat',
          ),
          const NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: AppTheme.saffronRed),
            label: 'Mandi',
          ),
          const NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb, color: AppTheme.saffronRed),
            label: 'Nuskhe',
          ),
        ],
      ),
    );
  }
}
