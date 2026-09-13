import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/plant.dart';

class PlantApiService {
  // Using Perenual API (free tier available)
  // You can get a free API key from https://perenual.com/
  static const String _baseUrl = 'https://perenual.com/api';
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with your actual API key
  
  // Search for plants by name
  Future<List<Plant>> searchPlants(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/species-list?key=$_apiKey&q=$query'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> plantsData = data['data'] ?? [];
        
        return plantsData.map((plantData) {
          return Plant(
            id: plantData['id']?.toString() ?? '',
            name: plantData['common_name'] ?? 'Unknown Plant',
            type: plantData['category'] ?? 'Indoor Plant',
            image: plantData['default_image']?['original_url'] ?? 
                   plantData['default_image']?['regular_url'] ?? 
                   'assets/images/flower1.png',
            light: _parseLightRequirement(plantData['lighting']),
            water: _parseWaterRequirement(plantData['watering']),
            humidity: '40-60%',
            overview: plantData['description'] ?? 
                      'A beautiful plant that will brighten up your space.',
            tips: [
              'Keep in ${plantData['lighting'] ?? 'bright indirect light'}',
              'Water ${plantData['watering'] ?? 'when soil is dry'}',
            ],
            addedDate: DateTime.now(),
          );
        }).toList();
      } else {
        if (kDebugMode) {
          print('API Error: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Search failed: $e');
      }
      return [];
    }
  }

  // Get detailed plant information by ID
  Future<Plant?> getPlantDetails(int plantId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/species/details/$plantId?key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        return Plant(
          id: data['id']?.toString() ?? '',
          name: data['common_name'] ?? 'Unknown Plant',
          type: data['category'] ?? 'Indoor Plant',
          image: data['default_image']?['original_url'] ?? 
                 data['default_image']?['regular_url'] ?? 
                 'assets/images/flower1.png',
          light: _parseLightRequirement(data['lighting']),
          water: _parseWaterRequirement(data['watering']),
          humidity: _parseHumidity(data['humidity']),
          overview: data['description'] ?? 
                    'A beautiful plant that will brighten up your space.',
          tips: _parseCareTips(data),
          addedDate: DateTime.now(),
        );
      } else {
        if (kDebugMode) {
          print('API Error: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Get details failed: $e');
      }
      return null;
    }
  }

  // Parse light requirement from API data
  String _parseLightRequirement(dynamic lighting) {
    if (lighting == null) return 'Bright, indirect light';
    
    final lightStr = lighting.toString().toLowerCase();
    if (lightStr.contains('full sun')) return 'Full sun';
    if (lightStr.contains('partial')) return 'Partial shade';
    if (lightStr.contains('shade')) return 'Low light';
    if (lightStr.contains('bright')) return 'Bright, indirect light';
    
    return 'Bright, indirect light';
  }

  // Parse water requirement from API data
  String _parseWaterRequirement(dynamic watering) {
    if (watering == null) return 'Every 7-10 days';
    
    final waterStr = watering.toString().toLowerCase();
    if (waterStr.contains('frequent')) return 'Every 3-5 days';
    if (waterStr.contains('average')) return 'Every 7-10 days';
    if (waterStr.contains('minimum') || waterStr.contains('rare')) return 'Every 2-3 weeks';
    
    return 'Every 7-10 days';
  }

  // Parse humidity from API data
  String _parseHumidity(dynamic humidity) {
    if (humidity == null) return '40-60%';
    
    final humidityStr = humidity.toString().toLowerCase();
    if (humidityStr.contains('high')) return '60-80%';
    if (humidityStr.contains('low')) return '30-40%';
    
    return '40-60%';
  }

  // Parse care tips from API data
  List<String> _parseCareTips(Map<String, dynamic> data) {
    final List<String> tips = [];
    
    if (data['lighting'] != null) {
      tips.add('Provide ${data['lighting']}');
    }
    
    if (data['watering'] != null) {
      tips.add('Water ${data['watering']}');
    }
    
    if (data['pruning_month'] != null) {
      tips.add('Best pruning time: ${data['pruning_month']}');
    }
    
    if (tips.isEmpty) {
      tips.add('Keep soil moist but not waterlogged');
      tips.add('Provide adequate drainage');
    }
    
    return tips;
  }

  // Get popular plants (for discovery)
  Future<List<Plant>> getPopularPlants() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/species-list?key=$_apiKey&page=1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> plantsData = data['data'] ?? [];
        
        return plantsData.take(10).map((plantData) {
          return Plant(
            id: plantData['id']?.toString() ?? '',
            name: plantData['common_name'] ?? 'Unknown Plant',
            type: plantData['category'] ?? 'Indoor Plant',
            image: plantData['default_image']?['original_url'] ?? 
                   plantData['default_image']?['regular_url'] ?? 
                   'assets/images/flower1.png',
            light: _parseLightRequirement(plantData['lighting']),
            water: _parseWaterRequirement(plantData['watering']),
            humidity: '40-60%',
            overview: plantData['description'] ?? 
                      'A beautiful plant that will brighten up your space.',
            tips: [
              'Keep in ${plantData['lighting'] ?? 'bright indirect light'}',
              'Water ${plantData['watering'] ?? 'when soil is dry'}',
            ],
            addedDate: DateTime.now(),
          );
        }).toList();
      } else {
        if (kDebugMode) {
          print('API Error: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Get popular plants failed: $e');
      }
      return [];
    }
  }
}
