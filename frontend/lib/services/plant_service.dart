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

    var request = http.MultipartRequest('POST', Uri.parse('${ApiConfig.baseUrl}/identify'));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      // For now, return dummy data without making a real request
      await Future.delayed(const Duration(seconds: 2));
      return {
        'name': 'Tomato',
        'description': 'The tomato is the edible berry of the plant Solanum lycopersicum.',
        'family': 'Solanaceae',
        'category': 'Fruit',
        'uses': 'Culinary',
        'tags': ['edible', 'vegetable'],
        'image_url': 'https://via.placeholder.com/300'
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
} 