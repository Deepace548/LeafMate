class Plant {
  final String id;
  final String name;
  final String type;
  final String image;
  final String light;
  final String water;
  final String humidity;
  final String overview;
  final List<String> tips;
  final DateTime addedDate;

  Plant({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.light,
    required this.water,
    required this.humidity,
    required this.overview,
    this.tips = const [],
    required this.addedDate,
  });

  // ==================== JSON ENCODE ====================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
      'light': light,
      'water': water,
      'humidity': humidity,
      'overview': overview,
      'tips': tips,
      'addedDate': addedDate.toIso8601String(),
    };
  }

  // ==================== JSON DECODE (SAFE) ====================
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      light: json['light']?.toString() ?? '',
      water: json['water']?.toString() ?? '',
      humidity: json['humidity']?.toString() ?? '',
      overview: json['overview']?.toString() ?? '',
      tips: _parseTips(json['tips']),
      addedDate: _parseDate(json['addedDate']),
    );
  }

  // ==================== HELPERS ====================
  static List<String> _parseTips(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  // ==================== COPY WITH (optional) ====================
  Plant copyWith({
    String? id,
    String? name,
    String? type,
    String? image,
    String? light,
    String? water,
    String? humidity,
    String? overview,
    List<String>? tips,
    DateTime? addedDate,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      image: image ?? this.image,
      light: light ?? this.light,
      water: water ?? this.water,
      humidity: humidity ?? this.humidity,
      overview: overview ?? this.overview,
      tips: tips ?? this.tips,
      addedDate: addedDate ?? this.addedDate,
    );
  }
}