import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pantry_item.dart';

class RasoiProvider extends ChangeNotifier {
  List<PantryItem> _items = [];
  final List<WasteLog> _wasteLogs = [];
  List<MandiItem> _mandiList = [];
  double _totalSaved = 1420.0;
  final int _streakDays = 9;

  List<PantryItem> get items => _items;
  List<WasteLog> get wasteLogs => _wasteLogs;
  List<MandiItem> get mandiList => _mandiList;
  double get totalSaved => _totalSaved;
  int get streakDays => _streakDays;

  double get totalWasted =>
      _wasteLogs.fold(0.0, (sum, log) => sum + log.rupeesLost);

  int get urgentCount => _items
      .where(
        (i) => i.urgency == UrgencyLevel.urgentToday || i.daysRemaining <= 1,
      )
      .length;

  RasoiProvider() {
    _loadInitialData();
  }

  void _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('bhandaar_items');
    if (cached != null) {
      try {
        final List decoded = jsonDecode(cached);
        _items = decoded.map((e) => PantryItem.fromJson(e)).toList();
      } catch (_) {
        _seedDefaultItems();
      }
    } else {
      _seedDefaultItems();
    }
    _seedMandiList();
    notifyListeners();
  }

  void _persistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.map((i) => i.toJson()).toList());
    await prefs.setString('bhandaar_items', encoded);
  }

  void _seedDefaultItems() {
    _items = [
      PantryItem(
        id: 'p_1',
        hindiName: 'Hara Dhania',
        englishName: 'Fresh Coriander',
        category: 'Sabzi & Greens',
        quantity: '1 Bunch',
        storageZone: StorageZone.crisperDrawer,
        daysRemaining: 1,
        urgency: UrgencyLevel.urgentToday,
        approxValueRupees: 20.0,
        storageTip:
            'Roots in water jar with muslin cloth cover; trim soggy leaves.',
        rescueIdea: 'Spicy Dhania-Pudina Thecha or Green Chutney',
        dateAdded: DateTime.now().subtract(const Duration(days: 4)),
      ),
      PantryItem(
        id: 'p_2',
        hindiName: 'Desi Tamatar',
        englishName: 'Ripe Tomatoes',
        category: 'Sabzi & Greens',
        quantity: '800 g',
        storageZone: StorageZone.crisperDrawer,
        daysRemaining: 1,
        urgency: UrgencyLevel.urgentToday,
        approxValueRupees: 45.0,
        storageTip:
            'Stem-down on counter at room temperature; do not refrigerate unripe.',
        rescueIdea: 'South Indian Tomato Rasam or Instant Chutney',
        dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      ),
      PantryItem(
        id: 'p_3',
        hindiName: 'Taaza Paneer',
        englishName: 'Fresh Malai Paneer',
        category: 'Dairy & Doodh',
        quantity: '200 g',
        storageZone: StorageZone.fridgeTop,
        daysRemaining: 2,
        urgency: UrgencyLevel.useSoon,
        approxValueRupees: 90.0,
        storageTip:
            'Submerge in lightly salted water bowl; change water daily.',
        rescueIdea: 'Paneer Bhurji with toasted bread or Parathas',
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PantryItem(
        id: 'p_4',
        hindiName: 'Palak Saag',
        englishName: 'Spinach Bunches',
        category: 'Sabzi & Greens',
        quantity: '500 g',
        storageZone: StorageZone.crisperDrawer,
        daysRemaining: 3,
        urgency: UrgencyLevel.useSoon,
        approxValueRupees: 35.0,
        storageTip:
            'Dry completely with paper napkin before storing in airtight dabba.',
        rescueIdea: 'Lehsuni Palak Dal or Palak Puri dough',
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PantryItem(
        id: 'p_5',
        hindiName: 'Pahadi Aloo',
        englishName: 'Potatoes',
        category: 'Dry & Root',
        quantity: '2.5 kg',
        storageZone: StorageZone.dryRack,
        daysRemaining: 12,
        urgency: UrgencyLevel.freshSafe,
        approxValueRupees: 75.0,
        storageTip: 'Store in dark airy tokri; keep away from onions.',
        rescueIdea: 'Aloo Jeera or Dum Aloo',
        dateAdded: DateTime.now().subtract(const Duration(days: 1)),
      ),
      PantryItem(
        id: 'p_6',
        hindiName: 'Toor / Arhar Dal',
        englishName: 'Pigeon Pea Lentils',
        category: 'Dal & Anaj',
        quantity: '1.5 kg',
        storageZone: StorageZone.dryRack,
        daysRemaining: 60,
        urgency: UrgencyLevel.freshSafe,
        approxValueRupees: 210.0,
        storageTip:
            'Add 2 dried red chillies or bay leaf to prevent ghun insect infestation.',
        rescueIdea: 'Tadka Dal or Sambhar',
        dateAdded: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  void _seedMandiList() {
    _mandiList = [
      MandiItem(
        id: 'm_1',
        hindiName: 'Adrak & Lehsan',
        englishName: 'Ginger & Garlic Combo',
        category: 'Masale & Aromatics',
        quantity: '250 g',
        estimatedPrice: 60.0,
      ),
      MandiItem(
        id: 'm_2',
        hindiName: 'Nimbu',
        englishName: 'Lemons',
        category: 'Sabzi & Greens',
        quantity: '6 Pcs',
        estimatedPrice: 30.0,
      ),
      MandiItem(
        id: 'm_3',
        hindiName: 'Taaza Dahi',
        englishName: 'Curd / Yogurt',
        category: 'Dairy & Doodh',
        quantity: '500 g',
        estimatedPrice: 40.0,
      ),
    ];
  }

  void addItem(PantryItem item) {
    _items.insert(0, item);
    _persistItems();
    notifyListeners();
  }

  void markEaten(String id) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx != -1) {
      final item = _items[idx];
      _totalSaved += item.approxValueRupees;
      _items.removeAt(idx);
      _persistItems();
      notifyListeners();
    }
  }

  void moveToFreezer(String id) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _items[idx].storageZone = StorageZone.freezer;
      _items[idx].daysRemaining += 14;
      _items[idx].recalculateUrgency();
      _persistItems();
      notifyListeners();
    }
  }

  void logWasted(String id, String reason) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx != -1) {
      final item = _items[idx];
      _wasteLogs.insert(
        0,
        WasteLog(
          id: 'w_${DateTime.now().millisecondsSinceEpoch}',
          itemName: '${item.hindiName} (${item.englishName})',
          rupeesLost: item.approxValueRupees,
          reason: reason.isEmpty ? 'Expired in fridge' : reason,
          timestamp: DateTime.now(),
        ),
      );
      _items.removeAt(idx);
      _persistItems();
      notifyListeners();
    }
  }

  void rescueCook(double rupeesSaved, List<String> rescuedIngredients) {
    _totalSaved += rupeesSaved;
    _items.removeWhere(
      (item) => rescuedIngredients.any(
        (res) => item.hindiName.contains(res) || item.englishName.contains(res),
      ),
    );
    _persistItems();
    notifyListeners();
  }

  void toggleMandiItem(String id) {
    final idx = _mandiList.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _mandiList[idx].isChecked = !_mandiList[idx].isChecked;
      notifyListeners();
    }
  }

  void addMandiItem(MandiItem item) {
    _mandiList.add(item);
    notifyListeners();
  }

  void removeMandiItem(String id) {
    _mandiList.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void transferCheckedMandiToPantry() {
    final checked = _mandiList.where((i) => i.isChecked).toList();
    for (final m in checked) {
      _items.add(
        PantryItem(
          id: 'p_mandi_${DateTime.now().millisecondsSinceEpoch}_${m.id}',
          hindiName: m.hindiName,
          englishName: m.englishName,
          category: m.category,
          quantity: m.quantity,
          storageZone: StorageZone.crisperDrawer,
          daysRemaining: m.category.contains('Dairy') ? 2 : 6,
          urgency: UrgencyLevel.freshSafe,
          approxValueRupees: m.estimatedPrice,
          storageTip: 'Freshly bought from Mandi. Stored in clean dabba.',
          rescueIdea: 'Daily sabzi or fresh cooking',
          dateAdded: DateTime.now(),
        ),
      );
    }
    _mandiList.removeWhere((i) => i.isChecked);
    _persistItems();
    notifyListeners();
  }

  void importSimulatedScannedItems(List<PantryItem> scanned) {
    _items.addAll(scanned);
    _persistItems();
    notifyListeners();
  }
}
