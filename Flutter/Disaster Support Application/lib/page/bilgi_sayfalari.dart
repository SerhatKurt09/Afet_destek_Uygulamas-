import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class BilgiSayfalari extends StatefulWidget {
  @override
  _BilgiSayfalariState createState() => _BilgiSayfalariState();
}

class _BilgiSayfalariState extends State<BilgiSayfalari> {
  List bilgiler = [];

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  Future<void> loadJson() async {
    String data = await rootBundle.loadString('assets/data/bilgiler.json');
    setState(() {
      bilgiler = json.decode(data);
    });
  }

  @override
  void initState() {
    super.initState();
    loadJson();

    _videoPlayerController = VideoPlayerController.asset('assets/images/Afet_Farkindalik_Egitimi.mp4');
    _videoPlayerController.initialize().then((_) {
      _videoPlayerController.setVolume(1.0); // SES AÇIK
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: false,
          looping: false,
        );
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: Text('Acil Durum Bilgileri'),
        backgroundColor: const Color(0xFF0084FF),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_chewieController != null && _videoPlayerController.value.isInitialized)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Bilgilendirme İçeriği",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bilgiler.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      bilgiler[index]['baslik'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0084FF),
                      ),
                    ),
                    subtitle: Text(
                      bilgiler[index]['icerik'],
                      style: const TextStyle(
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
