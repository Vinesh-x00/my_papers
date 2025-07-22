import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_papers/pages/auth_page.dart';
import 'package:my_papers/pages/new_password.dart';
import 'package:my_papers/theme.dart' as theme;
import 'package:provider/provider.dart';
 
import 'package:my_papers/models/note_database.dart';

final _storage = FlutterSecureStorage();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notedb = await NoteDatabase.create();
  runApp(
    ChangeNotifierProvider(
      create: (context) => notedb,
      child: MyApp(),
    ),
  );

}


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.darkMode,
      home: FutureBuilder<String?>(
        future: _storage.read(key: 'password_hash'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.data != null) {
            return AuthPage();
          } else {
            return PasswordCreation();
          }
        },
      ),
    );
  }
}
