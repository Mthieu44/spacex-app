import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacex_app/data/api/rocket.service.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/data/models/rocket.model.dart';

class LaunchService {
  LaunchService._();
  static final LaunchService instance = LaunchService._();

  final String baseUrl = "https://api.spacexdata.com/v4/launches";
  final http.Client client = http.Client();
  final RocketService rocketService = RocketService.instance;

  Future<List<LaunchModel>> fetchAllLaunches() async {
    final response = await client.get(Uri.parse(baseUrl));
    final List<LaunchModel> launches = [];
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      for (var launchData in data) {
        final launch = LaunchModel.fromJson(launchData);
        final rocketId = launchData['rocket'] as String;
        launch.rocket = await rocketService.fetchRocketById(rocketId);
        launches.add(launch);
      }
      return launches;
    } else {
      throw Exception('Failed to load launches');
    }
  }
}