import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class MythService {

  // GET myths (pagination)
  static Future<Map<String, dynamic>> getMyths(int page) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.myths}?page=$page&per_page=10"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load myths");
    }
  }

  // POST generate myths
  static Future<void> generateMyth(String theme, int total) async {
    final response = await http.post(
      Uri.parse(ApiConstants.generateMyth),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "theme": theme,
        "total": total
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to generate myths");
    }
  }
} 