import 'package:flutter/material.dart';
import 'local_database.dart';
import 'sync_data.dart';

class DBViewScreen extends StatefulWidget {
  const DBViewScreen({super.key});

  @override
  State<DBViewScreen> createState() => _DBViewScreenState();
}

class _DBViewScreenState extends State<DBViewScreen> {
  Map<String, Map<String, dynamic>?> _dbData = {};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final data = <String, Map<String, dynamic>?>{
      'users': await LocalDatabase.instance.getUsers(),
      'about_yourself': await LocalDatabase.instance.getAboutYourself(),
      'lifestyle': await LocalDatabase.instance.getLifestyle(),
      'notification': await LocalDatabase.instance.getNotification(),
      'physical_info': await LocalDatabase.instance.getPhysicalInfo(),
      'profile': await LocalDatabase.instance.getProfile(),
    };

    setState(() {
      _dbData = data;
      _loading = false;
    });
  }

  Future<void> _deleteAll() async {
    await LocalDatabase.instance.clearAll();
    await _loadData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🗑️ All local data deleted')),
    );
  }

  Future<void> _syncFromFirestore() async {
    setState(() => _loading = true);
    await SyncService().syncFromFirestore();
    await _loadData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Synced from Firestore')),
    );
  }

  Future<void> _syncToFirestore() async {
    setState(() => _loading = true);
    await SyncService().syncToFirestore();
    await _loadData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Synced to Firestore')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📦 Local DB Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download),
            tooltip: 'Sync from Firestore',
            onPressed: _syncFromFirestore,
          ),
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Sync from Firestore',
            onPressed: _syncToFirestore,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete all',
            onPressed: _deleteAll,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: _dbData.entries.map((entry) {
                final table = entry.key;
                final data = entry.value;

                return ExpansionTile(
                  title: Text('📁 $table'),
                  children: data != null
                      ? data.entries
                          .map((e) => ListTile(
                                title: Text(e.key),
                                subtitle: Text(e.value.toString()),
                              ))
                          .toList()
                      : [const ListTile(title: Text('No data'))],
                );
              }).toList(),
            ),
    );
  }
}
