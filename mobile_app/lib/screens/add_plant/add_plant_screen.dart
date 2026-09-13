import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/plant.dart';
import '../../services/plant_storage_service.dart';
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
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  static const Color brandGreen = Color(0xFF286B47);

  Plant? _selected;
  bool _saving = false;

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
                  const Text(
                    'Add Plant',
                    style: TextStyle(
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
                        'What is the plant you want to add',
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

    // Give it a UNIQUE id so multiple adds don't clash
    final newPlant = Plant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _selected!.name,
      type: _selected!.type,
      image: _selected!.image,
      light: _selected!.light,
      water: _selected!.water,
      humidity: _selected!.humidity,
      overview: _selected!.overview,
      tips: _selected!.tips,
      addedDate: DateTime.now(),
    );

    try {
      final storage = PlantStorageService();
      await storage.addPlant(newPlant);
    } catch (e) {
      debugPrint('Save failed: $e');
    }

    if (!mounted) return;

    Navigator.pop(context);
  }
}