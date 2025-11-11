import 'package:spacex_app/data/models/launch_links.model.dart';
import 'package:spacex_app/data/models/rocket.model.dart';

class LaunchModel {
  final String id;
  final String name;
  final DateTime dateTime;
  final LaunchLinks links;
  final String details;
  final bool success;
  final bool upcoming;
  final List<String> failures;
  RocketModel? rocket;
  bool favorite;

  LaunchModel({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.links,
    required this.details,
    required this.success,
    required this.upcoming,
    required this.failures,
    this.rocket,
    this.favorite = false,
  });

  factory LaunchModel.fromJson(Map<String, dynamic> json) {
    return LaunchModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dateTime: DateTime.parse(json['date_utc'] as String),
      links: LaunchLinks.fromJson(json['links'] as Map<String, dynamic>),
      details: json['details'] as String? ?? 'No details available.',
      success: json['success'] as bool? ?? false,
      upcoming: json['upcoming'] as bool? ?? false,
      failures: (json['failures'] as List<dynamic>?)
              ?.map((e) => e['reason'] as String)
              .toList() ?? [],
      favorite: json['favorite'] as bool? ?? false,
    );
  }

  String get formattedDate {
    String month = _months[dateTime.month - 1];
    return '${dateTime.day} $month ${dateTime.year}';
  }

  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} UTC';
  }

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_utc': dateTime.toIso8601String(),
      'links': links.toJson(),
      'details': details,
      'success': success,
      'upcoming': upcoming,
      'failures': failures.map((reason) => {'reason': reason}).toList(),
      'favorite': favorite,
    };
  }
}

