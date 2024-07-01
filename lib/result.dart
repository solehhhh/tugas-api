import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek/data/user.dart';
import 'package:projek/detail.dart';
import 'package:projek/register_page.dart';

class Result extends StatefulWidget {
  final int userId;

  Result({required this.userId});

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser(widget.userId);
  }

  Future<User> fetchUser(int id) async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return User.fromJson(json['data']);
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Detail'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            User user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      user.avatar,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('ID: ${user.id}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('First Name: ${user.firstName}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Last Name: ${user.lastName}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Back'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}
