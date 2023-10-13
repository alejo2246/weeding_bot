import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoPlayerWidget2 extends StatefulWidget {
  const VideoPlayerWidget2({
    Key? key,
  }) : super(key: key);

  @override
  VideoPlayerWidget2State createState() => VideoPlayerWidget2State();
}

class VideoPlayerWidget2State extends State<VideoPlayerWidget2> {
  ValueNotifier<bool> showNextChapterButton = ValueNotifier<bool>(false);
  late final VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    _controller = VlcPlayerController.asset(
      'assets/videos/video.mp4',
      options: VlcPlayerOptions(),
    );
    _controller.addOnInitListener(() async {
      await _controller.startRendererScanning();
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _controller.stopRecording();
    await _controller.stopRendererScanning();
    await _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_controller.value.isInitialized) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: VlcPlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
          );
        }),
        Positioned(
          left: 16, // Ajusta la posición izquierda según sea necesario
          bottom: 16, // Ajusta la posición inferior según sea necesario
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward, color: Colors.white),
                  onPressed: () {
                    // Lógica para el botón de flecha hacia arriba
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward, color: Colors.white),
                  onPressed: () {
                    // Lógica para el botón de flecha hacia abajo
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 16, // Ajusta la posición derecha según sea necesario
          bottom: 16, // Ajusta la posición inferior según sea necesario
          child: ElevatedButton(
            onPressed: () {
              // Lógica para el botón "Deshierbar"
            },
            child: Text("Deshierbar"),
          ),
        ),
      ],
    );
    // }
    // else {
    //   return Container(
    //     color: Colors.black,
    //     child: const Center(
    //       child: CircularProgressIndicator(
    //         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8471F5)),
    //         backgroundColor: Colors.white,
    //       ),
    //     ),
    //   );
    // }
  }
}
