import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AyarlarPage extends StatefulWidget {
  @override
  _AyarlarPageState createState() => _AyarlarPageState();
}

class _AyarlarPageState extends State<AyarlarPage> {
  final TextEditingController _numara1 = TextEditingController();
  final TextEditingController _numara2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNumbers();
  }

  Future<void> _loadNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    _numara1.text = prefs.getString('numara1') ?? '';
    _numara2.text = prefs.getString('numara2') ?? '';
  }

  Future<void> _saveNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('numara1', _numara1.text);
    await prefs.setString('numara2', _numara2.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kaydedildi')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayarlar'), backgroundColor: const Color(0xFF0084FF), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _numara1, decoration: InputDecoration(labelText: 'Kişi 1 Numarası')),
            SizedBox(height: 12),
            TextField(controller: _numara2, decoration: InputDecoration(labelText: 'Kişi 2 Numarası')),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveNumbers,
              child: Text('Kaydet'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0084FF)),
            ),
          ],
        ),
      ),
    );
  }
}
