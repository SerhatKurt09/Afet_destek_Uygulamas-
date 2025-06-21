import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YardimEdinPage extends StatefulWidget {
  @override
  _YardimEdinPageState createState() => _YardimEdinPageState();
}

class _YardimEdinPageState extends State<YardimEdinPage> {
  final Telephony telephony = Telephony.instance;
  List<String> numaralar = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((granted) {
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gerekli izinler verilmedi!')),
        );
      } else {
        _loadNumbers();
      }
    });
  }

  Future<bool> _requestPermissions() async {
    // SMS izni
    bool smsGranted = await telephony.requestSmsPermissions ?? false;

    // Konum izni
    LocationPermission locPermission = await Geolocator.checkPermission();
    if (locPermission == LocationPermission.denied ||
        locPermission == LocationPermission.deniedForever) {
      locPermission = await Geolocator.requestPermission();
    }

    return smsGranted &&
        (locPermission == LocationPermission.always ||
            locPermission == LocationPermission.whileInUse);
  }

  Future<void> _loadNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    String? numara1 = prefs.getString('numara1');
    String? numara2 = prefs.getString('numara2');

    setState(() {
      numaralar = [];
      if (numara1 != null && numara1.isNotEmpty) numaralar.add(numara1);
      if (numara2 != null && numara2.isNotEmpty) numaralar.add(numara2);
    });
  }

  Future<void> _sendSmsWithLocation() async {
    if (numaralar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Numaralar ayarlanmadı! Lütfen Ayarlardan numara ekleyin.')),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String message =
          'Yardım Edin!!!. Konumum: https://maps.google.com/?q=${position.latitude},${position.longitude}';

      for (var numara in numaralar) {
        await telephony.sendSms(to: numara, message: message);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesajlar gönderildi!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj gönderilirken hata: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yardım Edin'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _sendSmsWithLocation,
          child: Text('Yardım Edin Mesajı Gönder'),
        ),
      ),
    );
  }
}
