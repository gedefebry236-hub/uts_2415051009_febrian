import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise_model.dart';

class ApiService {
  // Tetap panggil endpoint asli (tambahkan status=2 agar server memprioritaskan data valid)
  static const String _baseUrl = 'https://wger.de/api/v2/exercise/?language=2&status=2&limit=15';

  Future<List<ExerciseModel>> fetchExercises() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        // Kita kirimkan urutan data (index) ke dalam Model untuk fallback
        return results.asMap().entries.map((e) => ExerciseModel.fromJson(e.value, e.key)).toList();
      } else {
        throw Exception('Gagal memuat data dari server');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}