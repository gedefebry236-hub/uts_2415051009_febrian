class ExerciseModel {
  final int id;
  final String name;
  final String description;

  ExerciseModel({
    required this.id, 
    required this.name, 
    required this.description
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json, int index) {
    String rawName = json['name']?.toString() ?? '';
    String rawDesc = json['description']?.toString() ?? '';

    // Membersihkan teks dari tag HTML bawaan API
    String cleanName = rawName.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    String cleanDesc = rawDesc.replaceAll(RegExp(r'<[^>]*>'), '').trim();

    // Diperbanyak menjadi 15 gerakan unik agar tidak ada teks yang berulang di layar
    List<String> fallbackNames = [
      'Pull-up', 'Push-up', 'Dips', 'Muscle-up', 'Pistol Squat',
      'Front Lever', 'Back Lever', 'Planche', 'Handstand', 'L-Sit',
      'Human Flag', 'Dragon Flag', 'Tuck Planche', 'Burpee', 'Hanging Leg Raise'
    ];
    
    List<String> fallbackDescs = [
      'Latihan punggung atas dengan menarik tubuh ke bar.',
      'Latihan dada dan trisep dengan mendorong tubuh dari lantai.',
      'Latihan dada bagian bawah menggunakan parallel bar.',
      'Kombinasi gerakan pull-up dan dip yang eksplosif.',
      'Jongkok dengan satu kaki untuk melatih keseimbangan otot paha.',
      'Menahan tubuh sejajar menghadap ke atas menahan gravitasi.',
      'Menahan tubuh sejajar lantai menghadap ke bawah.',
      'Menahan tubuh sejajar lantai dengan tumpuan kedua tangan.',
      'Berdiri secara terbalik bertumpu pada tangan.',
      'Menahan tubuh dengan tangan sementara kaki lurus ke depan.',
      'Menahan tubuh lurus menyamping pada tiang vertikal.',
      'Latihan core ekstrem dengan mengangkat seluruh tubuh lurus ke atas.',
      'Versi dasar planche dengan lutut ditekuk ke arah dada.',
      'Kombinasi lompat dan push-up untuk kardio seluruh tubuh.',
      'Menggantung di bar dan mengangkat kaki lurus hingga 90 derajat.'
    ];

    int safeIndex = index % fallbackNames.length;

    return ExerciseModel(
      id: json['id'] ?? index,
      name: cleanName.isEmpty ? fallbackNames[safeIndex] : cleanName,
      description: cleanDesc.isEmpty ? fallbackDescs[safeIndex] : cleanDesc,
    );
  }
}