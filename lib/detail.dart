import 'package:flutter/material.dart';
import 'package:projek/data/user.dart';

// Definisi kelas DetailPage yang merupakan StatelessWidget
class DetailPage extends StatelessWidget {
  // Properti final yang bernama user dari tipe User
  final User user;

  // Konstruktor DetailPage dengan parameter yang dibutuhkan
  const DetailPage({required this.user});

  @override
  Widget build(BuildContext context) {
    // Membangun widget Scaffold sebagai kerangka utama halaman
    return Scaffold(
      // AppBar dengan title yang berisi nama depan dan nama belakang user
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      // Body dari Scaffold yang berisi konten halaman
      body: Padding(
        // Padding di sekitar konten halaman
        padding: const EdgeInsets.all(16.0),
        // Kolom yang menampilkan informasi user secara vertikal
        child: Column(
          // Menyelaraskan konten kolom di tengah
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar avatar user dari URL dengan lebar 120 dan fit cover
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
              radius: 60,
            ),
            SizedBox(height: 28), // Memberikan jarak vertikal sebesar 28
            // Menampilkan ID user dengan gaya teks yang diperbesar dan bold
            Text(
              'ID: ${user.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8), // Memberikan jarak vertikal sebesar 8
            // Menampilkan nama depan user dengan gaya teks yang diperbesar
            Text(
              'First Name: ${user.firstName}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8), // Memberikan jarak vertikal sebesar 8
            // Menampilkan nama belakang user dengan gaya teks yang diperbesar
            Text(
              'Last Name: ${user.lastName}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8), // Memberikan jarak vertikal sebesar 8
            // Menampilkan email user dengan gaya teks yang diperbesar dan warna abu-abu
            Text(
              'Email: ${user.email}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
