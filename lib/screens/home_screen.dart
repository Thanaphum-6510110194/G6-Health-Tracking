import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),

      body: Column(
        children: [

          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),

          Expanded(
            child: ListView(
              children: <Widget>[

                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Go to Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BasicProfileScreen()),
                    );
                  },
                ),
                const Divider(),
                
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Go to Dashboard'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}