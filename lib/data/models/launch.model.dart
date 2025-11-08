class LaunchModel {
  final String id;
  final String name;
  final DateTime dateTime;
  final String patchUrl;
  final String details;
  final bool success;
  bool favorite = false;

  LaunchModel({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.patchUrl,
    required this.details,
    required this.success,
  });

  factory LaunchModel.fromJson(Map<String, dynamic> json) {
    return LaunchModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dateTime: DateTime.parse(json['date_utc'] as String),
      patchUrl: json['links']['patch']['large'] as String? ?? '',
      details: json['details'] as String? ?? 'No details available.',
      success: json['success'] as bool? ?? false,
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
}

