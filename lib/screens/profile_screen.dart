import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pembuat'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Avatar Profil
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[200],
              child: const Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 24),
            // Nama & NIM
            const Text(
              'Febrian',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'NIM: 2415051009',
              style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            
            // Kartu Informasi
            _buildInfoCard(Icons.school, 'Program Studi', 'Pendidikan Teknik Informatika'),
            const SizedBox(height: 12),
            _buildInfoCard(Icons.account_balance, 'Universitas', 'Universitas Pendidikan Ganesha (UNDIKSHA)'),
            const SizedBox(height: 12),
            _buildInfoCard(Icons.code, 'Project UTS', 'CaliSplit - Aplikasi Kalistenik'),
          ],
        ),
      ),
    );
  }

  // Widget custom untuk membuat kartu info agar kode rapi (Reusable Widget)
  Widget _buildInfoCard(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.blue[800], size: 28),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
      ),
    );
  }
}