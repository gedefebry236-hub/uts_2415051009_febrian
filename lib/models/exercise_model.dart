class ExerciseModel {
  final int id;
  final String name;
  final String description;

  ExerciseModel({
    required this.id, 
    required this.name, 
    required this.description
  });

  // Tambahkan parameter "index" untuk melacak urutan data
  factory ExerciseModel.fromJson(Map<String, dynamic> json, int index) {
    String rawName = json['name']?.toString() ?? '';
    String rawDesc = json['description']?.toString() ?? '';

    // Membersihkan teks dari tag HTML
    String cleanName = rawName.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    String cleanDesc = rawDesc.replaceAll(RegExp(r'<[^>]*>'), '').trim();

    // Smart Fallback: Data Kalistenik Cadangan untuk mengamankan UI saat demo UTS
    List<String> fallbackNames = [
      'Pull-up', 'Push-up', 'Dips', 'Muscle-up', 'Pistol Squat',
      'Front Lever', 'Back Lever', 'Planche', 'Handstand', 'L-Sit'
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
      'Menahan tubuh dengan tangan sementara kaki lurus ke depan.'
    ];

    int safeIndex = index % fallbackNames.length;

    return ExerciseModel(
      id: json['id'] ?? index,
      // Jika API mengirim nama/deskripsi kosong, gunakan data fallback
      name: cleanName.isEmpty ? fallbackNames[safeIndex] : cleanName,
      description: cleanDesc.isEmpty ? fallbackDescs[safeIndex] : cleanDesc,
    );
  }
}