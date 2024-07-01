import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek/data/user.dart';
import 'package:projek/detail.dart';
import 'package:projek/register_page.dart';
import 'package:projek/find.dart';

class ListUser extends StatefulWidget {
  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  late Future<List<User>> futureUsers;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers(currentPage);
  }

  Future<List<User>> fetchUsers(int page) async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> data = json['data'];

      return data.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _changePage(int page) {
    setState(() {
      currentPage = page;
      futureUsers = fetchUsers(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pengguna'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      User user = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                            radius: 30,
                          ),
                          title: Text('${user.firstName} ${user.lastName}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(user: user),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text('Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Warna hijau
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FindUser(),
                          ),
                        );
                      },
                      child: Text('Find'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Warna oranye
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 1
                          ? () => _changePage(currentPage - 1)
                          : null,
                      child: Text('Previous'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Warna merah
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: currentPage < 2
                          ? () => _changePage(currentPage + 1)
                          : null,
                      child: Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Warna biru
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
