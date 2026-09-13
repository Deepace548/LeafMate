import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/plant.dart';
import '../../theme/app_colors.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;
  const PlantDetailScreen({super.key, required this.plant});

  static const Color brandGreen = Color(0xFF286B47);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ==================== HEADER ====================
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: brandGreen,
                    ),
                  ),
                  const Spacer(),

                  // 👇 EXACT logo image from assets
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          'assets/images/leafmate_logo.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.eco,
                            color: brandGreen,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'LeafMate',
                        style: TextStyle(
                          color: brandGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: brandGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      color: brandGreen,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // ==================== CONTENT ====================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F2E9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      plant.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.local_florist,
                          color: brandGreen,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _overviewItem(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Sunlight',
                        value: plant.light,
                      ),
                      _overviewItem(
                        icon: Icons.water_drop_outlined,
                        title: 'Water',
                        value: plant.water,
                      ),
                      _overviewItem(
                        icon: Icons.air,
                        title: 'Humidity',
                        value: plant.humidity,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Icon(Icons.eco, color: brandGreen, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Care Tips',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAF9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      plant.overview,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        height: 1.55,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: brandGreen, size: 26),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}