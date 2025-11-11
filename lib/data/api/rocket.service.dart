import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rocket.model.dart';

class RocketService {
  RocketService._();
  static final RocketService instance = RocketService._();

  final String baseUrl = "https://api.spacexdata.com/v4/rockets";
  final http.Client client = http.Client();

  final Map<String, RocketModel> _rocketCache = {};

  Future<RocketModel> fetchRocketById(String id) async {
    if (_rocketCache.containsKey(id)) {
      return _rocketCache[id]!;
    }
    final response = await client.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final rocket = RocketModel.fromJson(data);
      _rocketCache[id] = rocket;
      return rocket;
    } else {
      throw Exception('Failed to load rocket');
    }
  }
}