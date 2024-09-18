import 'dart:convert';
import 'package:FarmVeda/model/camera_way_model.dart';
import 'package:FarmVeda/shared/config.dart';
import 'package:http/http.dart' as http;
// import 'package:frontend/models/disease_prediction.dart';

class ApiService {
  static const String baseUrl = Config.serverUrl;
  // static String baseUrl = 'https://enbow.pythonanywhere.com';

  // static const String baseUrl = 'http://10.0.2.2:8000';

  Future<DiseasePrediction> predictDisease(
      String imagePath, String plantName, List<String> symptoms) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));
      request.fields['name'] = plantName;
      symptoms.forEach((symptom) {
        request.fields['symptoms[]'] = symptom;
      });

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        return DiseasePrediction.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to predict disease: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }

  Future<Map<String, dynamic>> predictDiseaseFromSymptoms({
    required String name,
    required String location,
    required List<String> symptoms,
    required String environment,
    required String age,
  }) async {
    final uri = Uri.parse('$baseUrl/predict_disease_from_symptoms');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'location': location,
          'symptoms': symptoms,
          'environment': environment,
          'age': age,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to predict disease: ${response.body}');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error connecting to the server: $e');
    }
  }
}
