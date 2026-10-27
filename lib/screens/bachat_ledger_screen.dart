import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/rasoi_provider.dart';
import '../theme/app_theme.dart';

class BachatLedgerScreen extends StatelessWidget {
  const BachatLedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RasoiProvider>();
    final netSavings = provider.totalSaved - provider.totalWasted;
    final totalTurnover = provider.totalSaved + provider.totalWasted;
    final efficiencyRate = totalTurnover > 0
        ? ((provider.totalSaved / totalTurnover) * 100).round()
        : 100;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderGrey),
          ),
          child: Column(
            children: [
              const Text(
                'Ghar Ki Net Bachat (Total Saved)',
                style: TextStyle(color: AppTheme.mutedText, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                '₹${netSavings.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.forestEmerald,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem(
                    'Saved',
                    '₹${provider.totalSaved.toStringAsFixed(0)}',
                    AppTheme.forestEmerald,
                  ),
                  Container(width: 1, height: 30, color: AppTheme.borderGrey),
                  _statItem(
                    'Wasted',
                    '₹${provider.totalWasted.toStringAsFixed(0)}',
                    AppTheme.urgentLalText,
                  ),
                  Container(width: 1, height: 30, color: AppTheme.borderGrey),
                  _statItem(
                    'Efficiency',
                    '$efficiencyRate%',
                    AppTheme.turmericAmber,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.soonPeelaBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.soonPeelaText.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppTheme.soonPeelaText,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${provider.streakDays} Din Ka Zero-Waste Streak! 🔥',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.soonPeelaText,
                        fontSize: 13,
                      ),
                    ),
                    const Text(
                      'No vegetables rotted in your rasoi for over a week.',
                      style: TextStyle(fontSize: 12, color: AppTheme.darkStone),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Waste Logs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${provider.wasteLogs.length} Records',
              style: const TextStyle(color: AppTheme.mutedText, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (provider.wasteLogs.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: const Center(
              child: Text(
                'Shandar! No food waste logged yet this month.',
                style: TextStyle(
                  color: AppTheme.forestEmerald,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          ...provider.wasteLogs.map((log) {
            final dateStr = DateFormat('dd MMM, hh:mm a').format(log.timestamp);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.urgentLalBg,
                  child: Icon(
                    Icons.delete_outline,
                    color: AppTheme.urgentLalText,
                    size: 18,
                  ),
                ),
                title: Text(
                  log.itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '${log.reason} • $dateStr',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedText,
                  ),
                ),
                trailing: Text(
                  '-₹${log.rupeesLost.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppTheme.urgentLalText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.mutedText),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
