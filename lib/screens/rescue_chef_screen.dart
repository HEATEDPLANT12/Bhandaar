import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rasoi_provider.dart';
import '../models/pantry_item.dart';
import '../theme/app_theme.dart';

class RescueChefScreen extends StatelessWidget {
  const RescueChefScreen({super.key});

  List<RescueRecipe> _getRecipes(List<PantryItem> pantry) {
    return [
      RescueRecipe(
        id: 'rec_1',
        title: 'Shahi Lehsuni Palak & Toor Dal',
        hindiSubtitle: 'लहसुनी पालक दाल',
        description:
            'Tender wilted spinach tempered with ghee, browned garlic, and cumin into cooked toor dal.',
        coreIngredientsRescued: ['Hara Dhania', 'Palak Saag', 'Desi Tamatar'],
        pantryAddons: ['Toor Dal', 'Ghee', 'Garlic', 'Hing', 'Jeera'],
        prepMinutes: 20,
        difficulty: 'Easy',
        approxSavingsRupees: 65.0,
        cookingSteps: [
          'Boil 1 cup Toor dal with turmeric and salt in a pressure cooker for 3 whistles.',
          'Chop expiring palak and tomatoes finely.',
          'Heat 1 tbsp ghee in a kadhai, crackle jeera, hing, and 6 minced garlic cloves until golden brown.',
          'Add chopped tomatoes, fry till soft, then add spinach and saute for 3 minutes.',
          'Pour in cooked dal, simmer on low heat for 5 minutes, garnish with dhania stems.',
        ],
        desiTip:
            'Use thick stems of dhania too - they carry 80% of aromatic flavour and essential vitamins.',
      ),
      RescueRecipe(
        id: 'rec_2',
        title: 'Dhaba Style Kadhi Bhurji Paratha',
        hindiSubtitle: 'बची हुई सब्जी व पनीर पराठा',
        description:
            'Mash aging paneer with leftover sabzi, chopped green chillies and carom seeds into crispy stuffed parathas.',
        coreIngredientsRescued: ['Taaza Paneer', 'Hara Dhania'],
        pantryAddons: ['Atta (Wheat Flour)', 'Ajwain', 'Ghee', 'Hari Mirch'],
        prepMinutes: 15,
        difficulty: 'Quick',
        approxSavingsRupees: 90.0,
        cookingSteps: [
          'Crumble 200g paneer into a wide bowl.',
          'Add chopped coriander, green chillies, 1/2 tsp ajwain, pinch of garam masala, and salt.',
          'Roll out wheat dough balls, stuff generously with paneer mixture and seal edges.',
          'Toast on hot tawa with ghee till both sides develop golden crisp spots.',
          'Serve steaming hot with homemade dahi or mango pickle.',
        ],
        desiTip:
            'Adding ajwain prevents bloating and aids quick digestion of paneer fat.',
      ),
      RescueRecipe(
        id: 'rec_3',
        title: 'Spicy Tamatar & Pudina Chutney Rice',
        hindiSubtitle: 'तीखा टमाटर-पुदीना भात',
        description:
            'Over-ripe soft tomatoes stewed with mustard seeds, curry leaves, and tossed with day-old cooked rice.',
        coreIngredientsRescued: ['Desi Tamatar', 'Hara Dhania'],
        pantryAddons: [
          'Cooked Rice',
          'Mustard Seeds',
          'Curry Leaves',
          'Urad Dal',
        ],
        prepMinutes: 12,
        difficulty: 'Beginner',
        approxSavingsRupees: 45.0,
        cookingSteps: [
          'Puree or roughly chop soft tomatoes.',
          'Heat oil in a pan, add mustard seeds, urad dal, and let them turn crunchy golden.',
          'Add curry leaves, turmeric, and tomato puree; cook until oil separates on edges.',
          'Fold in leftover cold rice gently without breaking grains.',
          'Finish with chopped coriander and roasted peanuts.',
        ],
        desiTip:
            'Soft over-ripe tomatoes have higher natural glutamate, yielding deeper savory rasam flavours.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RasoiProvider>();
    final recipes = _getRecipes(provider.items);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.saffronRed, AppTheme.spiceRust],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Desi Rescue Chef AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                'Prioritizing ingredients expiring within 24-48 hours into delicious Indian kitchen dishes.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'Personalized Rescue Recipes (${recipes.length})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ...recipes.map((recipe) => _buildRecipeCard(context, provider, recipe)),
      ],
    );
  }

  Widget _buildRecipeCard(
    BuildContext context,
    RasoiProvider provider,
    RescueRecipe recipe,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        recipe.hindiSubtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.saffronRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.safeHaraBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+₹${recipe.approxSavingsRupees.toStringAsFixed(0)} Bachat',
                    style: const TextStyle(
                      color: AppTheme.safeHaraText,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recipe.description,
              style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: recipe.coreIngredientsRescued.map((ing) {
                return Chip(
                  avatar: const Icon(
                    Icons.check_circle,
                    size: 14,
                    color: AppTheme.forestEmerald,
                  ),
                  label: Text(
                    'Rescues $ing',
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: AppTheme.safeHaraBg.withValues(alpha: 0.4),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            const Text(
              'Step-by-step method:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ...recipe.cookingSteps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}. ',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              );
            }),
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
                    Icons.psychology_outlined,
                    size: 16,
                    color: AppTheme.turmericAmber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dadi Tip: ${recipe.desiTip}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.darkStone,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.saffronRed,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text(
                  'Cooked This! Save ₹ & Update Pantry',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  provider.rescueCook(
                    recipe.approxSavingsRupees,
                    recipe.coreIngredientsRescued,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '🎉 Rescued! ₹${recipe.approxSavingsRupees.toStringAsFixed(0)} credited to your Bachat Ledger.',
                      ),
                      backgroundColor: AppTheme.forestEmerald,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
