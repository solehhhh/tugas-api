import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result.dart';

class FindUser extends StatefulWidget {
  const FindUser({super.key});

  @override
  State<FindUser> createState() => _FindUserState();
}

class _FindUserState extends State<FindUser> {
  final TextEditingController _inputIdController = TextEditingController();

  Future<void> _findUser() async {
    final String id = _inputIdController.text;

    if (id.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse('https://reqres.in/api/users/$id'),
        );

        // Log response to the console
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          // Display a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User found: ${responseData['data']['first_name']} ${responseData['data']['last_name']}'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to the Result page with the user ID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Result(userId: int.parse(id)),
            ),
          );
        } else {
          // Display an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to find user'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Display an error message if there is an exception
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Display a warning message if ID is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter an ID'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find User'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Find User by ID',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _inputIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "ID",
                    hintText: "Enter user ID",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _findUser,
                    child: Text("Find"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.amber, padding: EdgeInsets.symmetric(vertical: 16.0), // Change text color to black
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
