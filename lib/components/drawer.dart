import 'package:flutter/material.dart';
import 'package:my_papers/pages/setting_page.dart';

///Sidebar page for app
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(Icons.note),
          ),
          /// Home button
          ListTile(
            title: Text("Notes"),
            leading: Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),
          /// To setting page
          ListTile(
            title: Text("Setting"),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
