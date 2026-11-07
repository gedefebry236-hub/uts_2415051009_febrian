import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil API saat halaman pertama kali dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseProvider>(context, listen: false).fetchExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Gerakan (API)'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100], // Background terang agar Card lebih menonjol
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          // State 1: Loading
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // State 2: Error
          if (provider.error.isNotEmpty) {
            return Center(
              child: Text('Gagal memuat data: ${provider.error}', style: const TextStyle(color: Colors.red)),
            );
          }

          // State 3: Data Kosong
          if (provider.exercises.isEmpty) {
            return const Center(child: Text('Tidak ada data gerakan.'));
          }

          // State 4: Sukses (Responsive Layout)
          return LayoutBuilder(
            builder: (context, constraints) {
              // Jika dibuka di Tablet/Web (layar lebar), gunakan GridView
              if (constraints.maxWidth > 600) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: provider.exercises.length,
                  itemBuilder: (context, index) {
                    return _buildExerciseCard(provider.exercises[index]);
                  },
                );
              } 
              // Jika di HP, gunakan ListView
              else {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.exercises.length,
                  itemBuilder: (context, index) {
                    return _buildExerciseCard(provider.exercises[index]);
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  // Widget terpisah untuk mendesain Kartu List agar kode utama tetap rapi
  Widget _buildExerciseCard(exercise) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16), // Jarak antar kartu
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Ikon Kotak Placeholder di sebelah kiri
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.sports_gymnastics, color: Colors.blue[800], size: 36),
            ),
            const SizedBox(width: 16),
            
            // Teks Nama & Deskripsi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exercise.description,
                    maxLines: 2, // Membatasi deskripsi maksimal 2 baris
                    overflow: TextOverflow.ellipsis, // Menambahkan "..." jika kepanjangan
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}