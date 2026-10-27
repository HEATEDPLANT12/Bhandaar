import 'package:flutter/material.dart';
import '../models/pantry_item.dart';
import '../theme/app_theme.dart';

class NuskheScreen extends StatelessWidget {
  const NuskheScreen({super.key});

  List<NuskheItem> _getNuskhe() {
    return [
      NuskheItem(
        title: 'Fresh Coriander (Hara Dhania)',
        hindiTitle: 'हरा धनिया को 15 दिन ताज़ा रखें',
        category: 'Greens',
        technique:
            'Cut muddy root tips. Submerge stems in 1 inch clean water jar. Cover leaves with breathable cotton muslin (malmal) cloth.',
        shelfLifeBoost: '+10 Days',
        whyItWorks:
            'Prevents bacterial slime while supplying water capillary flow through natural xylem vessels.',
      ),
      NuskheItem(
        title: 'Green Chillies (Hari Mirch)',
        hindiTitle: 'हरी मिर्च का डंठल तोड़कर रखें',
        category: 'Spices',
        technique:
            'Pluck off all green stems. Line an airtight Tupperware or steel dabba with dry kitchen tissue paper.',
        shelfLifeBoost: '+14 Days',
        whyItWorks:
            'The stem is the initial site of fungal spores and moisture condensation that causes rapid softening.',
      ),
      NuskheItem(
        title: 'Lemons (Nimbu)',
        hindiTitle: 'नींबू पर सरसों का तेल लगाएं',
        category: 'Citrus',
        technique:
            'Lightly massage lemon rind with 2 drops of mustard oil or submerge whole lemons in a clean water bowl in fridge.',
        shelfLifeBoost: '+20 Days',
        whyItWorks:
            'Mustard oil acts as a hydrophobic antimicrobial sealant preventing dehydration and black fungal spots.',
      ),
      NuskheItem(
        title: 'Ginger & Garlic (Adrak-Lehsan)',
        hindiTitle: 'अदरक को सूखा और हवादार रखें',
        category: 'Aromatics',
        technique:
            'Never store unpeeled ginger in sealed polythene. Keep in an open jute tokri with garlic.',
        shelfLifeBoost: '+25 Days',
        whyItWorks:
            'Trapped ethylene gas and condensation catalyze mold growth on root surfaces.',
      ),
      NuskheItem(
        title: 'Fresh Paneer (Malai Paneer)',
        hindiTitle: 'पनीर को हल्के नमक के पानी में रखें',
        category: 'Dairy',
        technique:
            'Immerse block in cold water with 1/4 tsp rock salt (sendha namak). Change water every 24 hours.',
        shelfLifeBoost: '+5 Days',
        whyItWorks:
            'Saline water halts acidic bacterial whey fermentation without toughening milk protein fibers.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final list = _getNuskhe();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
          ),
          child: const Row(
            children: [
              Icon(Icons.auto_stories, color: Color(0xFFD97706), size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dadi-Nani Desi Codex',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF92400E),
                      ),
                    ),
                    Text(
                      'Time-tested Indian kitchen wisdom to extend vegetable & dairy shelf life.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        ...list.map(
          (nuskhe) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nuskhe.hindiTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              nuskhe.title,
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
                          color: AppTheme.safeHaraBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          nuskhe.shelfLifeBoost,
                          style: const TextStyle(
                            color: AppTheme.safeHaraText,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nuskhe.technique,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.creamBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.science_outlined,
                          size: 14,
                          color: AppTheme.forestEmerald,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Why it works: ${nuskhe.whyItWorks}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
