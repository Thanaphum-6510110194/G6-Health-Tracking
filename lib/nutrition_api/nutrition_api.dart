import 'dart:convert';
import 'package:http/http.dart' as http;

// ✅ ใช้ ID และ KEY ที่คุณให้มา
const String appId = '68ef8364';
const String apiKey = 'ab332b04b342e1aeb03941e90704ee7d';

Future<Map<String, dynamic>> fetchNutritionixData(String query) async {
  final url = Uri.parse('https://trackapi.nutritionix.com/v2/natural/nutrients');

  final response = await http.post(
    url,
    headers: {
      'x-app-id': appId,
      'x-app-key': apiKey,
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'query': query}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch nutrition data: ${response.body}');
  }
}
