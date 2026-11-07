import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../services/api_service.dart';

class ExerciseProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<ExerciseModel> _exercises = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<ExerciseModel> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadExercises() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Memberitahu UI untuk menampilkan loading

    try {
      _exercises = await _apiService.fetchExercises();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Memberitahu UI bahwa proses selesai
    }
  }
}