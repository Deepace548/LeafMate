import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ---------- Plant illustration (big, full width) ----------
            SizedBox(
              width: double.infinity,
              height: 360,
              child: Image.asset(
                'assets/images/flower.jpeg',
                fit: BoxFit.fitWidth,
              ),
            ),

            const SizedBox(height: 32),

            // ---------- "No Plants Yet!" — BLACK ----------
            const Text(
              "No Plants Yet!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,          // 👈 BLACK
              ),
            ),

            const SizedBox(height: 10),

            // ---------- Subtitle ----------
            const Text(
              "Add your first plant to start tracking",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}