import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:telephony/telephony.dart';

class HaritaPage extends StatefulWidget {
  @override
  _HaritaPageState createState() => _HaritaPageState();
}

class _HaritaPageState extends State<HaritaPage> {
  LatLng? _currentPosition;
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    telephony.requestSmsPermissions;  // SMS izni isteği
  }

  Future<void> _determinePosition() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } else {
      setState(() {
        _currentPosition = LatLng(39.0, 35.0); // Sabit konum
      });
    }
  }

  // Share Plus ile genel paylaşım
  void _konumMetniPaylas() {
    if (_currentPosition != null) {
      final metin = 'Benim konumum:\nEnlem: ${_currentPosition!.latitude}\nBoylam: ${_currentPosition!.longitude}';
      Share.share(metin);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konum alınamadı')),
      );
    }
  }

  // Otomatik SMS ile 112’ye konum gönderme (Android)
  void _smsGonder() async {
    if (_currentPosition != null) {
      final mesaj =
          'Acil Destek! Benim konumum:\nEnlem: ${_currentPosition!.latitude}\nBoylam: ${_currentPosition!.longitude}';
      final alici = '112';

      bool? izin = await telephony.requestSmsPermissions;
      if (izin == true) {
        telephony.sendSms(to: alici, message: mesaj);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SMS gönderildi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SMS gönderme izni verilmedi')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konum alınamadı')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Harita & Konum Paylaşımı"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _konumMetniPaylas,
          ),
          IconButton(
            icon: const Icon(Icons.sms),
            onPressed: _smsGonder, // SMS butonu eklendi
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _currentPosition!,
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentPosition!,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
