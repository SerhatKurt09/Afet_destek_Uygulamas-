import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:telephony/telephony.dart';

class AcilNumaralar extends StatelessWidget {
  final Map<String, String> numaralar = {
    '112 - Acil Sağlık': '112',
    '110 - İtfaiye': '110',
    '155 - Polis': '155',
    
  };

  final Telephony telephony = Telephony.instance;

  void _ara(String numara) async {
    final Uri uri = Uri(scheme: 'tel', path: numara);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Hata mesajı gösterilebilir
    }
  }

  void _smsGonder(String mesaj, BuildContext context) async {
    final Uri smsUri = Uri(scheme: 'sms', queryParameters: {'body': mesaj});
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SMS açılamadı')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Acil Numaralar'),
        backgroundColor: const Color(0xFF0084FF),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: numaralar.entries.map((entry) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              title: Text(
                entry.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone, color: Color(0xFF0084FF)),
                    onPressed: () => _ara(entry.value),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sms, color: Color(0xFF0084FF)),
                    onPressed: () => _smsGonder('Lütfen yardım gönderin! Numara: ${entry.value}', context),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
