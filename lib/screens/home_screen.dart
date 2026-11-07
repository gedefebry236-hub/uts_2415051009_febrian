import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> _fetchLogs() async {
    return await _supabase
        .from('split_logs')
        .select()
        .order('created_at', ascending: false);
  }

  Future<void> _deleteLog(int id) async {
    try {
      await _supabase.from('split_logs').delete().eq('id', id);
      setState(() {}); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus 🗑️'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      }
    }
  }

  Future<void> _updateLog(int id, String name, int sets, int reps, double weight) async {
    try {
      await _supabase.from('split_logs').update({
        'exercise_name': name,
        'sets': sets,
        'reps': reps,
        'weight': weight,
      }).eq('id', id);
      
      setState(() {}); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui ✏️'), backgroundColor: Colors.blue),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memperbarui: $e')));
      }
    }
  }

  void _showEditDialog(Map<String, dynamic> log) {
    final nameController = TextEditingController(text: log['exercise_name']);
    final setsController = TextEditingController(text: log['sets'].toString());
    final repsController = TextEditingController(text: log['reps'].toString());
    final weightController = TextEditingController(text: log['weight'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Rutinitas'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Gerakan')),
              TextField(controller: setsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Set')),
              TextField(controller: repsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Repetisi')),
              TextField(controller: weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Beban (Kg)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              _updateLog(
                log['id'],
                nameController.text,
                int.tryParse(setsController.text) ?? 0,
                int.tryParse(repsController.text) ?? 0,
                double.tryParse(weightController.text) ?? 0.0,
              );
            },
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Kalistenik'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final logs = snapshot.data ?? [];
          final totalRoutines = logs.length; // Menghitung total data

          return Column(
            children: [
              // KARTU RINGKASAN UI BARU
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[800]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Rutinitas Tersimpan',
                      style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalRoutines',
                      style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // LIST DATA RUTINITAS
              Expanded(
                child: logs.isEmpty
                    ? const Center(
                        child: Text('Belum ada rutinitas. Yuk tambah di tab Routine!', style: TextStyle(fontSize: 16)),
                      )
                    : ListView.builder(
                        itemCount: logs.length,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          final dateString = log['date'].toString().split('T')[0];

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[100],
                                child: Icon(Icons.fitness_center, color: Colors.blue[800]),
                              ),
                              title: Text(log['exercise_name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              subtitle: Text('${log['sets']} Set x ${log['reps']} Reps\nBeban: ${log['weight']} Kg • Tanggal: $dateString'),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () => _showEditDialog(log),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Hapus Rutinitas?'),
                                          content: const Text('Yakin ingin menghapus catatan latihan ini?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteLog(log['id']);
                                              },
                                              child: const Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}