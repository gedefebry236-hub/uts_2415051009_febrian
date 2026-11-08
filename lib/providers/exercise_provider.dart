import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../services/api_service.dart';

class ExerciseProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<ExerciseModel> _exercises = [];
  bool _isLoading = false;
  String _error = '';

  List<ExerciseModel> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String get error => _error; // Getter 'error' yang dicari oleh ExploreScreen

  // Fungsi 'fetchExercises' yang dicari oleh ExploreScreen
  Future<void> fetchExercises() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _exercises = await _apiService.fetchExercises();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}