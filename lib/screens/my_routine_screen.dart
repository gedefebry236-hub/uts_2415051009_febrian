import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyRoutineScreen extends StatefulWidget {
  const MyRoutineScreen({super.key});

  @override
  State<MyRoutineScreen> createState() => _MyRoutineScreenState();
}

class _MyRoutineScreenState extends State<MyRoutineScreen> {
  // Key ini wajib ada untuk syarat validasi form dari dosen
  final _formKey = GlobalKey<FormState>();
  
  // Controller untuk mengambil teks yang diketik pengguna
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  
  bool _isLoading = false;

  // Fungsi untuk menyimpan data ke Supabase (Syarat CRUD - Create Data)
  Future<void> _saveRoutine() async {
    // 1. Cek validasi form, jika ada yang kosong, batalkan proses
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Munculkan efek loading
    });

    try {
      // 2. Mengirim data ke tabel 'split_logs' di Supabase
      await Supabase.instance.client.from('split_logs').insert({
        'exercise_name': _nameController.text,
        'sets': int.parse(_setsController.text),
        'reps': int.parse(_repsController.text),
        'weight': _weightController.text.isEmpty ? 0.0 : double.parse(_weightController.text),
        'date': DateTime.now().toIso8601String(), // Mengambil tanggal hari ini otomatis
      });

      // 3. Memunculkan notifikasi sukses berwarna hijau
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan ke Database! 🔥'), backgroundColor: Colors.green),
        );
        // Mengosongkan kolom isian setelah berhasil disimpan
        _nameController.clear();
        _setsController.clear();
        _repsController.clear();
        _weightController.clear();
      }
    } catch (e) {
      // 4. Memunculkan notifikasi error jika gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // Matikan efek loading
      });
    }
  }

  // Membersihkan memori saat halaman ditutup
  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Rutinitas'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Catat Latihan Kalistenikmu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Input Nama Gerakan
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Gerakan (Misal: Pull-up)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Nama gerakan wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Input Set dan Repetisi (Dibuat bersebelahan)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Set',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Repetisi',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Input Beban Tambahan (Opsional)
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Beban Tambahan / Weight (Kg) - Opsional',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.scale),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading ? null : _saveRoutine,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan ke Database', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}