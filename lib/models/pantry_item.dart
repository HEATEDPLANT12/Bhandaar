enum UrgencyLevel { urgentToday, useSoon, freshSafe }

enum StorageZone { crisperDrawer, fridgeTop, dryRack, freezer }

class PantryItem {
  final String id;
  final String hindiName;
  final String englishName;
  final String category;
  String quantity;
  StorageZone storageZone;
  int daysRemaining;
  UrgencyLevel urgency;
  double approxValueRupees;
  final String storageTip;
  final String rescueIdea;
  final DateTime dateAdded;

  PantryItem({
    required this.id,
    required this.hindiName,
    required this.englishName,
    required this.category,
    required this.quantity,
    required this.storageZone,
    required this.daysRemaining,
    required this.urgency,
    required this.approxValueRupees,
    required this.storageTip,
    required this.rescueIdea,
    required this.dateAdded,
  });

  void recalculateUrgency() {
    if (daysRemaining <= 1) {
      urgency = UrgencyLevel.urgentToday;
    } else if (daysRemaining <= 3) {
      urgency = UrgencyLevel.useSoon;
    } else {
      urgency = UrgencyLevel.freshSafe;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hindiName': hindiName,
    'englishName': englishName,
    'category': category,
    'quantity': quantity,
    'storageZone': storageZone.name,
    'daysRemaining': daysRemaining,
    'urgency': urgency.name,
    'approxValueRupees': approxValueRupees,
    'storageTip': storageTip,
    'rescueIdea': rescueIdea,
    'dateAdded': dateAdded.toIso8601String(),
  };

  factory PantryItem.fromJson(Map<String, dynamic> json) => PantryItem(
    id: json['id'],
    hindiName: json['hindiName'],
    englishName: json['englishName'],
    category: json['category'],
    quantity: json['quantity'],
    storageZone: StorageZone.values.firstWhere(
      (e) => e.name == json['storageZone'],
      orElse: () => StorageZone.crisperDrawer,
    ),
    daysRemaining: json['daysRemaining'],
    urgency: UrgencyLevel.values.firstWhere(
      (e) => e.name == json['urgency'],
      orElse: () => UrgencyLevel.freshSafe,
    ),
    approxValueRupees: (json['approxValueRupees'] as num).toDouble(),
    storageTip: json['storageTip'] ?? '',
    rescueIdea: json['rescueIdea'] ?? '',
    dateAdded: DateTime.tryParse(json['dateAdded'] ?? '') ?? DateTime.now(),
  );
}

class RescueRecipe {
  final String id;
  final String title;
  final String hindiSubtitle;
  final String description;
  final List<String> coreIngredientsRescued;
  final List<String> pantryAddons;
  final int prepMinutes;
  final String difficulty;
  final double approxSavingsRupees;
  final List<String> cookingSteps;
  final String desiTip;

  RescueRecipe({
    required this.id,
    required this.title,
    required this.hindiSubtitle,
    required this.description,
    required this.coreIngredientsRescued,
    required this.pantryAddons,
    required this.prepMinutes,
    required this.difficulty,
    required this.approxSavingsRupees,
    required this.cookingSteps,
    required this.desiTip,
  });
}

class WasteLog {
  final String id;
  final String itemName;
  final double rupeesLost;
  final String reason;
  final DateTime timestamp;

  WasteLog({
    required this.id,
    required this.itemName,
    required this.rupeesLost,
    required this.reason,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemName': itemName,
    'rupeesLost': rupeesLost,
    'reason': reason,
    'timestamp': timestamp.toIso8601String(),
  };

  factory WasteLog.fromJson(Map<String, dynamic> json) => WasteLog(
    id: json['id'],
    itemName: json['itemName'],
    rupeesLost: (json['rupeesLost'] as num).toDouble(),
    reason: json['reason'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class MandiItem {
  final String id;
  final String hindiName;
  final String englishName;
  final String category;
  String quantity;
  double estimatedPrice;
  bool isChecked;

  MandiItem({
    required this.id,
    required this.hindiName,
    required this.englishName,
    required this.category,
    required this.quantity,
    required this.estimatedPrice,
    this.isChecked = false,
  });
}

class NuskheItem {
  final String title;
  final String hindiTitle;
  final String category;
  final String technique;
  final String shelfLifeBoost;
  final String whyItWorks;

  NuskheItem({
    required this.title,
    required this.hindiTitle,
    required this.category,
    required this.technique,
    required this.shelfLifeBoost,
    required this.whyItWorks,
  });
}
