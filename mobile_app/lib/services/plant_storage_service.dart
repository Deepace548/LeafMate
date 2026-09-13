import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plant.dart';

class PlantStorageService extends ChangeNotifier {
  static const String _storageKey = 'plants';

  // ================== SINGLETON ==================
  static final PlantStorageService _instance =
      PlantStorageService._internal();

  factory PlantStorageService() => _instance;

  PlantStorageService._internal() {
    loadPlants();
  }
  // ================================================

  List<Plant> _plants = [];
  List<Plant> get plants => List.unmodifiable(_plants);

  Future<void> loadPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final String? plantsJson = prefs.getString(_storageKey);
    if (plantsJson != null) {
      final List decoded = jsonDecode(plantsJson);
      _plants = decoded.map((e) => Plant.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> addPlant(Plant plant) async {
    _plants.add(plant);
    await _save();
    notifyListeners();
  }

  Future<void> deletePlant(String id) async {
    _plants.removeWhere((p) => p.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> updatePlant(Plant updatedPlant) async {
    final index = _plants.indexWhere((p) => p.id == updatedPlant.id);
    if (index != -1) {
      _plants[index] = updatedPlant;
      await _save();
      notifyListeners();
    }
  }

  Future<void> clearAll() async {
    _plants.clear();
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
        jsonEncode(_plants.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}