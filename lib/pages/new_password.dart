import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_papers/models/utils.dart';

final storage = FlutterSecureStorage();

class PasswordCreation extends StatefulWidget {
  const PasswordCreation({super.key});

  @override
  State<PasswordCreation> createState() => _AuthPageState();
}

class _AuthPageState extends State<PasswordCreation> {
  final _newPasswordController = TextEditingController();
  final _retypeNewPasswordController = TextEditingController();
  String _msg = '';
  bool isValid = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _retypeNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> createPassword() async {
    String newpasswd = _newPasswordController.text;
    String retypepasswd = _retypeNewPasswordController.text;

    if (newpasswd.isEmpty || retypepasswd.isEmpty) {
      setState(() {
        _msg = "Password required";
      });
      return;
    }
    if (newpasswd != retypepasswd) {
      setState(() {
        _msg = "Password are not same";
      });
      return;
    }

    if (!mounted) {
      return;
    }

    String hashInput = hashSHA256(newpasswd);
    await storage.write(key: 'password_hash', value: hashInput);

    setState(() {
      isValid = true;
      _msg = 'Password created, restart the app';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                "Create Password",
                style: GoogleFonts.dmSerifText(
                  fontSize: 40,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(labelText: 'Enter New Password'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _retypeNewPasswordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(labelText: 'Retype New Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createPassword,
              child: Text('Enter'),
            ),
            SizedBox(height: 10),
            Text(_msg, style: TextStyle(color: isValid ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}
