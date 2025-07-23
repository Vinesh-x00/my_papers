import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_papers/models/aes_cipher.dart';
import 'package:my_papers/models/utils.dart';
import 'package:my_papers/pages/notes_pages.dart';

final storage = FlutterSecureStorage();

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _passwordController = TextEditingController();
  String _msg = '';

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> verifyPassword() async {
    String input = _passwordController.text;
    if (input.isEmpty) {
      return;
    }

    String hashInput = hashSHA256(input);
    String? storedHash = await storage.read(key: 'password_hash');

    if (!mounted) {
      return;
    }

    if (storedHash == hashInput) {
      GetIt.I.registerSingleton<AESCipher>(AESCipher(input));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NotesPage()),
        //MaterialPageRoute(builder: (_) => SettingPage()),
      );
    } else {
      setState(() {
        _msg = "Incorrect password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Auth",
                style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(labelText: 'Enter Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyPassword,
              child: Text('Enter'),
            ),
            SizedBox(height: 10),
            Text(_msg, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
