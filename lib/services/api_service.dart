import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise_model.dart';

class ApiService {
  // Mengambil 15 data gerakan dalam bahasa Inggris (language=2)
  static const String _baseUrl = 'https://wger.de/api/v2/exercise/?language=2&limit=15';

  Future<List<ExerciseModel>> fetchExercises() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        return results.map((e) => ExerciseModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat data dari server');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}