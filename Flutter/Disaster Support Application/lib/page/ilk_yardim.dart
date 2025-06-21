import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class IlkYardimPage extends StatefulWidget {
  @override
  _IlkYardimPageState createState() => _IlkYardimPageState();
}

class _IlkYardimPageState extends State<IlkYardimPage> {
  List yardimlar = [];

  Future<void> loadJson() async {
    String data = await rootBundle.loadString('assets/data/ilk_yardim.json');
    setState(() {
      yardimlar = json.decode(data);
    });
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('İlk Yardım Rehberi'),
        backgroundColor: const Color(0xFF0084FF),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: yardimlar.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  yardimlar[index]['resim'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                yardimlar[index]['baslik'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF333333),
                ),
              ),
              subtitle: Text(
                yardimlar[index]['icerik'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
