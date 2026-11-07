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
    // Memanggil fungsi fetch API saat halaman ini pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseProvider>(context, listen: false).loadExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Gerakan (API)'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      // Consumer untuk menangkap perubahan state dari Provider
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          // 1. Menangani Loading State (Syarat UTS)
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // 2. Menangani Error State (Syarat UTS)
          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }
          
          // 3. Menangani Empty State (Syarat UTS)
          if (provider.exercises.isEmpty) {
            return const Center(child: Text('Tidak ada data gerakan.'));
          }

          // 4. Responsive Layout menggunakan LayoutBuilder (Syarat UTS)
          return LayoutBuilder(
            builder: (context, constraints) {
              // Jika lebar layar lebih dari 600 pixel (Mode Tablet/Desktop) -> Pakai GridView
              if (constraints.maxWidth > 600) {
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 kotak menyamping
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: provider.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = provider.exercises[index];
                    return Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            // API wger menyertakan tag HTML, kita potong untuk display sederhana
                            Expanded(child: Text(exercise.description.replaceAll(RegExp(r'<[^>]*>'), ''), overflow: TextOverflow.fade)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              
              // Jika lebar layar kecil (Mode HP) -> Pakai ListView
              return ListView.builder(
                itemCount: provider.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = provider.exercises[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    elevation: 2,
                    child: ListTile(
                      title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      // Membersihkan tag HTML dari API wger
                      subtitle: Text(exercise.description.replaceAll(RegExp(r'<[^>]*>'), ''), maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Navigasi ke Detail Screen (Kita buat di langkah selanjutnya)
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}