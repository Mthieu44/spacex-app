import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacex_app/data/models/launch.model.dart';

class LaunchService {
  LaunchService._();
  static final LaunchService instance = LaunchService._();

  final String baseUrl = "https://api.spacexdata.com/v4/launches";
  final http.Client client = http.Client();

  Future<List<LaunchModel>> fetchAllLaunches() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LaunchModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load launches');
    }
  }
}