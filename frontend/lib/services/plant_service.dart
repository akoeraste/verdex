import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_config.dart';

class PlantService {
  Future<Map<String, dynamic>?> identifyPlant(File image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // Handle not logged in
      return null;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/identify'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      // For now, return dummy data without making a real request
      await Future.delayed(const Duration(seconds: 2));
      return {
        'name': 'Tomato',
        'description':
            'The tomato is the edible berry of the plant Solanum lycopersicum.',
        'family': 'Solanaceae',
        'category': 'Fruit',
        'uses': 'Culinary',
        'tags': ['edible', 'vegetable'],
        'image_url': 'https://via.placeholder.com/300',
      };
      /*
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = jsonDecode(responseData);
        return decodedData;
      }
      */
    } catch (e) {
      // Handle exceptions
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // Not logged in
      return [];
    }

    /*
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/plants'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
    */

    // Returning dummy data for now
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'id': 1,
        'name': 'Tomato',
        'description':
            'The tomato is the edible berry of the plant Solanum lycopersicum.',
        'family': 'Solanaceae',
        'category': 'Fruit',
        'uses': 'Culinary',
        'tags': ['edible', 'vegetable'],
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Bright_red_tomato_and_cross_section02.jpg/800px-Bright_red_tomato_and_cross_section02.jpg',
        'created_at': '2023-10-26T10:00:00.000000Z',
      },
      {
        'id': 2,
        'name': 'Basil',
        'description': 'A culinary herb of the family Lamiaceae.',
        'family': 'Lamiaceae',
        'category': 'Plant',
        'uses': 'Culinary, Medicinal',
        'tags': ['herb', 'green'],
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Basil-pesto.jpg/800px-Basil-pesto.jpg',
        'created_at': '2023-10-25T11:00:00.000000Z',
      },
      {
        'id': 3,
        'name': 'Carrot',
        'description': 'A root vegetable, typically orange in color.',
        'family': 'Apiaceae',
        'category': 'Plant',
        'uses': 'Culinary',
        'tags': ['root', 'vegetable'],
        'image_url':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Karotten.jpg/800px-Karotten.jpg',
        'created_at': '2023-10-24T12:00:00.000000Z',
      },
    ];
  }
}
