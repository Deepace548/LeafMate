import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/plant.dart';
import '../../services/plant_storage_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/plant_card.dart';
import '../add_plant/add_plant_screen.dart';
import '../plant_detail/plant_detail_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 👇 Singleton — same instance everywhere
  final storage = PlantStorageService();
  int _tab = 0;
  String _query = '';

  static const Color brandGreen = Color(0xFF286B47);

  @override
  void initState() {
    super.initState();
    storage.addListener(_onChange);
  }

  @override
  void dispose() {
    storage.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  List<Plant> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return storage.plants;
    return storage.plants
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // 👇 Black status bar icons on white background
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,   // Android
      statusBarBrightness: Brightness.light,      // iOS
    ));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [
            _homeTab(),
            _historyTab(),
            _profileTab(),
          ],
        ),
      ),
      floatingActionButton: _tab == 0
          ? SizedBox(
              width: 60,
              height: 60,
              child: FloatingActionButton(
                backgroundColor: brandGreen,
                shape: const CircleBorder(),
                elevation: 2,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddPlantScreen()),
                  );
                },
                child: const Icon(Icons.add,
                    color: Colors.white, size: 30),
              ),
            )
          : null,
      bottomNavigationBar: LeafBottomNavBar(
        index: _tab,
        onChanged: (i) => setState(() {
          _tab = i;
          if (i != 0) _query = '';    // clear search when leaving Home
        }),
      ),
    );
  }

  Widget _header({required bool search}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 34,
                height: 34,
                child: CustomPaint(
                  painter: _LeafOutlinePainter(brandGreen),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'LEAFMATE',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  fontSize: 17,
                  color: brandGreen,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh, color: Colors.black),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu, color: Colors.black),
              ),
            ],
          ),
          if (search)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search your plants',
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.grey),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _homeTab() {
    final plants = _filtered;
    return Column(
      children: [
        _header(search: true),
        Expanded(
          child: storage.plants.isEmpty
              ? const EmptyStateWidget()
              : ListView.separated(
                  padding:
                      const EdgeInsets.fromLTRB(20, 8, 20, 88),
                  itemCount: plants.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final plant = plants[i];
                    return PlantCard(
                      plant: plant,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PlantDetailScreen(plant: plant),
                          ),
                        );
                      },
                      onDelete: () => _confirmDelete(plant),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(Plant plant) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete plant?'),
        content:
            Text('Remove "${plant.name}" from your collection?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await storage.deletePlant(plant.id);
    }
  }

  Widget _historyTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(search: false),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Text('History',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700)),
        ),
        Expanded(
          child: storage.plants.isEmpty
              ? const Center(
                  child: Text('No care activity yet.',
                      style: TextStyle(color: AppColors.grey)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: storage.plants.length,
                  itemBuilder: (_, i) {
                    final p = storage.plants[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${p.name} added to collection',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _profileTab() {
    return Column(
      children: [
        _header(search: false),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${storage.plants.length} plant${storage.plants.length == 1 ? '' : 's'} in your collection',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
              child: const Text('Log out'),
            ),
          ),
        ),
      ],
    );
  }
}

// ================= Leaf logo — matches Figma reference =================
class _LeafOutlinePainter extends CustomPainter {
  final Color color;
  _LeafOutlinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final leaf = Path()
      ..moveTo(w * 0.30, h * 0.82)
      ..cubicTo(
        w * 0.15, h * 0.55,
        w * 0.30, h * 0.18,
        w * 0.72, h * 0.14,
      )
      ..cubicTo(
        w * 0.90, h * 0.20,
        w * 0.88, h * 0.42,
        w * 0.72, h * 0.62,
      )
      ..cubicTo(
        w * 0.60, h * 0.78,
        w * 0.45, h * 0.82,
        w * 0.30, h * 0.82,
      )
      ..close();

    canvas.drawPath(leaf, stroke);

    final vein = Path()
      ..moveTo(w * 0.30, h * 0.80)
      ..cubicTo(
        w * 0.45, h * 0.68,
        w * 0.58, h * 0.52,
        w * 0.72, h * 0.34,
      );
    canvas.drawPath(vein, stroke);

    final stem = Path()
      ..moveTo(w * 0.30, h * 0.80)
      ..cubicTo(
        w * 0.24, h * 0.88,
        w * 0.22, h * 0.94,
        w * 0.20, h * 0.98,
      );
    canvas.drawPath(stem, stroke);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}