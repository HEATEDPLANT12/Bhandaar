import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rasoi_provider.dart';
import '../models/pantry_item.dart';
import '../theme/app_theme.dart';

class ReceiptScanDialog extends StatefulWidget {
  const ReceiptScanDialog({super.key});

  @override
  State<ReceiptScanDialog> createState() => _ReceiptScanDialogState();
}

class _ReceiptScanDialogState extends State<ReceiptScanDialog> {
  bool _isScanning = false;
  List<PantryItem>? _scannedResults;

  void _runSimulatedScan() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isScanning = false;
      _scannedResults = [
        PantryItem(
          id: 'scan_1',
          hindiName: 'Gajar (Delhi Carrot)',
          englishName: 'Red Carrots',
          category: 'Sabzi & Greens',
          quantity: '1 kg',
          storageZone: StorageZone.crisperDrawer,
          daysRemaining: 7,
          urgency: UrgencyLevel.freshSafe,
          approxValueRupees: 50.0,
          storageTip: 'Cut green tops and store in perforated zip pouch.',
          rescueIdea: 'Gajar Matar Sabzi or Gajar Halwa',
          dateAdded: DateTime.now(),
        ),
        PantryItem(
          id: 'scan_2',
          hindiName: 'Hari Mirch',
          englishName: 'Green Chillies',
          category: 'Sabzi & Greens',
          quantity: '200 g',
          storageZone: StorageZone.crisperDrawer,
          daysRemaining: 10,
          urgency: UrgencyLevel.freshSafe,
          approxValueRupees: 25.0,
          storageTip: 'Remove stems, line box with dry tissue paper.',
          rescueIdea: 'Thecha or Green Tadka',
          dateAdded: DateTime.now(),
        ),
        PantryItem(
          id: 'scan_3',
          hindiName: 'Taaza Matar',
          englishName: 'Green Peas',
          category: 'Sabzi & Greens',
          quantity: '500 g',
          storageZone: StorageZone.crisperDrawer,
          daysRemaining: 4,
          urgency: UrgencyLevel.useSoon,
          approxValueRupees: 60.0,
          storageTip: 'Shell and freeze immediately in zip lock for 6 months.',
          rescueIdea: 'Matar Paneer or Aloo Matar',
          dateAdded: DateTime.now(),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Scan Mandi / Blinkit Bill',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_scannedResults == null) ...[
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.creamBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.borderGrey,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: _isScanning
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppTheme.saffronRed),
                          SizedBox(height: 12),
                          Text(
                            'Reading items & calculating shelf life...',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                            color: AppTheme.saffronRed,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Point camera at Mandi slip or Zepto receipt',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.mutedText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.saffronRed,
                            ),
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 16,
                            ),
                            label: const Text(
                              'Simulate OCR Bill Scan',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _runSimulatedScan,
                          ),
                        ],
                      ),
              ),
            ),
          ] else ...[
            Text(
              'Found ${_scannedResults!.length} items automatically!',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.forestEmerald,
              ),
            ),
            const SizedBox(height: 10),
            ..._scannedResults!.map(
              (item) => ListTile(
                dense: true,
                leading: const Icon(
                  Icons.check_circle,
                  color: AppTheme.forestEmerald,
                ),
                title: Text(
                  item.hindiName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${item.englishName} • ${item.quantity}'),
                trailing: Text('₹${item.approxValueRupees.toStringAsFixed(0)}'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.forestEmerald,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  context.read<RasoiProvider>().importSimulatedScannedItems(
                    _scannedResults!,
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add All to Rasoi Tokri',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
