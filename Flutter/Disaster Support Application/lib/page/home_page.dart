import 'package:flutter/material.dart';
import 'acil_numaralar.dart';
import 'yardim_edin.dart';
import 'bilgi_sayfalari.dart';
import 'ilk_yardim.dart';
import 'harita.dart';
import 'AyarlarPage.dart';
class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Acil Durum Bilgileri', 'page': BilgiSayfalari(), 'icon': Icons.info},
    {'title': 'Acil Numaralar', 'page': AcilNumaralar(), 'icon': Icons.phone},
    {'title': 'Yardım Edin', 'page': YardimEdinPage(), 'icon': Icons.warning},
    {'title': 'İlk Yardım Rehberi', 'page': IlkYardimPage(), 'icon': Icons.medical_services},
    {'title': 'Harita & Konum Paylaşımı', 'page': HaritaPage(), 'icon': Icons.map},
    {'title': 'Ayarlar', 'page': AyarlarPage(), 'icon': Icons.settings},
    

  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: Text('AFET DESTEK'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0084FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // En fazla 2 kutucuk yan yana
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['page']),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'],
                      size: 48,
                      color: const Color(0xFF0084FF),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
