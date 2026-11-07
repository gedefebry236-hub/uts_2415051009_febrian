class LogModel {
  final int? id;
  final String hariFokus;
  final String namaGerakan;
  final int targetRepetisi;
  final double beratBadan;

  LogModel({
    this.id,
    required this.hariFokus,
    required this.namaGerakan,
    required this.targetRepetisi,
    required this.beratBadan,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      id: json['id'],
      hariFokus: json['hari_fokus'],
      namaGerakan: json['nama_gerakan'],
      targetRepetisi: json['target_repetisi'],
      beratBadan: json['berat_badan'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'hari_fokus': hariFokus,
    'nama_gerakan': namaGerakan,
    'target_repetisi': targetRepetisi,
    'berat_badan': beratBadan,
  };
}