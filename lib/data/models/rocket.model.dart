class RocketModel {
  final String id;
  final String name;
  final String type;
  final String description;
  final bool active;
  final double height;
  final double diameter;
  final double mass;
  final String wikipedia;
  final List<String> images;

  RocketModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.active,
    required this.height,
    required this.diameter,
    required this.mass,
    required this.wikipedia,
    required this.images,
  });

  factory RocketModel.fromJson(Map<String, dynamic> json) {
    return RocketModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String? ?? 'No description available.',
      active: json['active'] as bool? ?? false,
      height: (json['height']['meters'] as num?)?.toDouble() ?? 0.0,
      diameter: (json['diameter']['meters'] as num?)?.toDouble() ?? 0.0,
      mass: (json['mass']['kg'] as num?)?.toDouble() ?? 0.0,
      wikipedia: json['wikipedia'] as String? ?? '',
      images: (json['flickr_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'active': active,
      'height': {'meters': height},
      'diameter': {'meters': diameter},
      'mass': {'kg': mass},
      'wikipedia': wikipedia,
      'flickr_images': images,
    };
  }
}