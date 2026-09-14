import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/plant.dart';
import '../../services/plant_storage_service.dart';
import '../../services/plant_api_service.dart';
import '../../theme/app_colors.dart';

// ==================== Plant catalog ====================
final List<Plant> plantCatalog = [
  Plant(
    id: '1',
    name: 'Croton Petra',
    type: 'Indoor Plant',
    image: 'assets/images/croton.png',
    light: 'Bright, indirect light',
    water: 'Every 5-7 days',
    humidity: '40-60%',
    overview:
        'Croton Petra is a colorful indoor plant that prefers bright light.',
    tips: [
      'Give it bright indirect light',
      'Keep the soil slightly moist',
    ],
    addedDate: DateTime.now(),
  ),
  Plant(
    id: '2',
    name: 'Monstera Deliciosa',
    type: 'Indoor Plant',
    image: 'assets/images/monstera.png',
    light: 'Bright, indirect light',
    water: 'Every 7-10 days',
    humidity: '50-70%',
    overview:
        'Monstera Deliciosa is a popular tropical indoor plant with large leaves.',
    tips: [
      'Avoid direct sunlight',
      'Water when the top soil feels dry',
    ],
    addedDate: DateTime.now(),
  ),
  Plant(
    id: '3',
    name: 'Snake Plant',
    type: 'Indoor Plant',
    image: 'assets/images/snake.png',
    light: 'Low to bright indirect light',
    water: 'Every 2-3 weeks',
    humidity: '30-50%',
    overview:
        'Snake Plant is an easy-care indoor plant that can tolerate low light.',
    tips: [
      'Do not overwater',
      'Allow soil to dry between watering',
    ],
    addedDate: DateTime.now(),
  ),
];

class AddPlantScreen extends StatefulWidget {
  final Plant? existingPlant;
  const AddPlantScreen({super.key, this.existingPlant});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  static const Color brandGreen = Color(0xFF286B47);

  Plant? _selected;
  bool _saving = false;
  bool _searching = false;
  List<Plant> _apiSearchResults = [];
  final TextEditingController _searchController = TextEditingController();
  final PlantApiService _apiService = PlantApiService();

  @override
  void initState() {
    super.initState();
    if (widget.existingPlant != null) {
      _selected = widget.existingPlant;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Black status bar icons
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ==================== HEADER ====================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.existingPlant != null ? 'Edit Plant' : 'Add Plant',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================== PLANT IMAGE (DYNAMIC) ====================
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.38,
              child: _selected == null
                  ? Image.asset(
                      'assets/images/flower1.png',   // 👈 CHANGED to .png
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.local_florist,
                          color: brandGreen,
                          size: 140,
                        ),
                      ),
                    )
                  : Image.asset(
                      _selected!.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.local_florist,
                          color: brandGreen,
                          size: 140,
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 70),

            // ==================== SEARCH BAR ====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search plant database...',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                    border: InputBorder.none,
                    suffixIcon: _searching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: brandGreen,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => _searchPlants(),
                          ),
                  ),
                  onSubmitted: (_) => _searchPlants(),
                ),
              ),
            ),

            // ==================== SEARCH RESULTS ====================
            if (_apiSearchResults.isNotEmpty)
              Container(
                height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _apiSearchResults.length,
                  itemBuilder: (context, index) {
                    final plant = _apiSearchResults[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selected = plant;
                          _apiSearchResults.clear();
                          _searchController.clear();
                        });
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selected?.id == plant.id
                                ? brandGreen
                                : Colors.grey.withOpacity(0.3),
                            width: _selected?.id == plant.id ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(11),
                              ),
                              child: Image.network(
                                plant.image,
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 80,
                                  color: AppColors.accent,
                                  child: const Icon(
                                    Icons.local_florist,
                                    color: brandGreen,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                plant.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // ==================== OR DIVIDER ====================
            if (_apiSearchResults.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: _apiSearchResults.isNotEmpty ? 16 : 0),

            // ==================== DROPDOWN ====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Plant>(
                    isExpanded: true,
                    hint: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Or select from catalog',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    value: _selected,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black87,
                      size: 22,
                    ),
                    selectedItemBuilder: (context) {
                      return plantCatalog.map((plant) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            plant.name,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    items: plantCatalog.map((plant) {
                      return DropdownMenuItem<Plant>(
                        value: plant,
                        child: Text(
                          plant.name,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (plant) {
                      setState(() {
                        _selected = plant;
                        _apiSearchResults.clear();
                        _searchController.clear();
                      });
                    },
                  ),
                ),
              ),
            ),

            const Spacer(),

            // ==================== DONE BUTTON ====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        brandGreen.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.4,
                          ),
                        )
                      : const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _onDone() async {
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a plant first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    // If editing, keep the original ID; if adding, create new ID
    final plant = Plant(
      id: widget.existingPlant?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _selected!.name,
      type: _selected!.type,
      image: _selected!.image,
      light: _selected!.light,
      water: _selected!.water,
      humidity: _selected!.humidity,
      overview: _selected!.overview,
      tips: _selected!.tips,
      addedDate: widget.existingPlant?.addedDate ?? DateTime.now(),
    );

    try {
      final storage = PlantStorageService();
      if (widget.existingPlant != null) {
        await storage.updatePlant(plant);
      } else {
        await storage.addPlant(plant);
      }
    } catch (e) {
      debugPrint('Save failed: $e');
    }

    if (!mounted) return;

    Navigator.pop(context, plant);
  }

  Future<void> _searchPlants() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _searching = true);

    final results = await _apiService.searchPlants(query);

    if (mounted) {
      setState(() {
        _searching = false;
        _apiSearchResults = results;
      });
    }
  }
}