import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../theme/app_colors.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFEEF2EF),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ==================== LEFT: NAME + STATS ====================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- NAME ROW (name + delete icon) ----
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plant.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),

                      // 👇 DELETE button (small, subtle)
                      if (onDelete != null)
                        GestureDetector(
                          onTap: onDelete,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: AppColors.error.withOpacity(0.8),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ---- 3 stat columns ----
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _stat(
                        icon: Icons.wb_sunny,
                        iconColor: const Color(0xFFF5A623),
                        line1: _lightLine1(plant.light),
                        line2: _lightLine2(plant.light),
                      ),
                      _stat(
                        icon: Icons.water_drop,
                        iconColor: const Color(0xFF4A90D9),
                        line1: _waterLine1(plant.water),
                        line2: _waterLine2(plant.water),
                      ),
                      _stat(
                        icon: Icons.opacity,
                        iconColor: const Color(0xFF7EC8E3),
                        line1: _humidityLine1(plant.humidity),
                        line2: _humidityLine2(plant.humidity),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ==================== RIGHT: PLANT IMAGE ====================
            SizedBox(
              width: 100,
              height: 120,
              child: Image.asset(
                plant.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_florist,
                    color: Color(0xFF286B47),
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== STAT WIDGET ====================
  Widget _stat({
    required IconData icon,
    required Color iconColor,
    required String line1,
    required String line2,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 6),
          Text(
            line1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Text(
            line2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HELPERS ====================

  String _lightLine1(String s) {
    final cleaned = s.replaceAll(',', '').replaceAll(' light', '');
    final parts = cleaned.split(' ');
    return parts.isNotEmpty ? parts.first : s;
  }

  String _lightLine2(String s) {
    final cleaned = s.replaceAll(',', '').replaceAll(' light', '');
    final parts = cleaned.split(' ');
    if (parts.length >= 2) return parts[1];
    return '';
  }

  String _waterLine1(String s) {
    final parts = s.split(' ');
    if (parts.length >= 2) return '${parts[0]} ${parts[1]}';
    return s;
  }

  String _waterLine2(String s) {
    final parts = s.split(' ');
    if (parts.length >= 3) return parts[2];
    return '';
  }

  String _humidityLine1(String s) {
    if (s.contains('%')) {
      final num = int.tryParse(s.split('-').first.replaceAll('%', '')) ?? 50;
      if (num < 40) return 'Low';
      if (num < 60) return 'Medium';
      return 'High';
    }
    return s;
  }

  String _humidityLine2(String s) => s;
}