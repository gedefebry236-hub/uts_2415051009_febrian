import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;

  // 1. Fungsi READ: Mengambil data dari Supabase
  Future<List<dynamic>> _fetchLogs() async {
    // Mengambil data dari tabel split_logs, diurutkan dari yang terbaru
    return await _supabase
        .from('split_logs')
        .select()
        .order('created_at', ascending: false);
  }

  // 2. Fungsi DELETE: Menghapus data dari Supabase
  Future<void> _deleteLog(int id) async {
    try {
      await _supabase.from('split_logs').delete().eq('id', id);
      setState(() {}); // Me-refresh layar setelah data dihapus
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus 🗑️'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Kalistenik'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      // FutureBuilder otomatis menangani proses loading saat mengambil data internet
      body: FutureBuilder<List<dynamic>>(
        future: _fetchLogs(),
        builder: (context, snapshot) {
          // State 1: Sedang Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // State 2: Terjadi Error Jaringan/Database
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          // State 3: Data masih kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Belum ada rutinitas. Yuk tambah di tab Routine!', style: TextStyle(fontSize: 16)),
            );
          }

          // State 4: Data berhasil diambil, tampilkan ke dalam ListView
          final logs = snapshot.data!;
          return ListView.builder(
            itemCount: logs.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final log = logs[index];
              // Memformat tanggal agar lebih rapi dibaca (mengambil bagian YYYY-MM-DD saja)
              final dateString = log['date'].toString().split('T')[0];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.fitness_center, color: Colors.white),
                  ),
                  title: Text(
                    log['exercise_name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    '${log['sets']} Set x ${log['reps']} Reps\nBeban: ${log['weight']} Kg • Tanggal: $dateString',
                  ),
                  isThreeLine: true,
                  // Tombol Hapus (Delete)
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Memunculkan dialog konfirmasi sebelum menghapus
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Rutinitas?'),
                          content: const Text('Yakin ingin menghapus catatan latihan ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Tutup dialog
                                _deleteLog(log['id']); // Eksekusi fungsi hapus
                              },
                              child: const Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}