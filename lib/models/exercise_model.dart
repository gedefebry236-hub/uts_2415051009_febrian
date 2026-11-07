class ExerciseModel {
  final int id;
  final String name;
  final String description;

  ExerciseModel({
    required this.id, 
    required this.name, 
    required this.description
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'Tidak ada deskripsi',
    );
  }
}