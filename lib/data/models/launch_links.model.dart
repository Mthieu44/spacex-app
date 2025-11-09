class LaunchLinks {
  final String article;
  final String webcast;
  final String wikipedia;
  final String patch;

  LaunchLinks({
    required this.article,
    required this.webcast,
    required this.wikipedia,
    required this.patch,
  });

  factory LaunchLinks.fromJson(Map<String, dynamic> json) {
    return LaunchLinks(
      article: json['article'] as String? ?? '',
      webcast: json['webcast'] as String? ?? '',
      wikipedia: json['wikipedia'] as String? ?? '',
      patch: json['patch']['large'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'article': article,
      'webcast': webcast,
      'wikipedia': wikipedia,
      'patch': {
        'large': patch,
      },
    };
  }
}