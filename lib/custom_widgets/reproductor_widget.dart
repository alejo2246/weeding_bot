import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:weeding_bot/controllers/scan_controller.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    Key? key,
  }) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  ValueNotifier<bool> showNextChapterButton = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_controller.value.isInitialized) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          debugPrint("lettuce in sight: ${controller.lettuceInSight}");
          return Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.lettuceInSight
                          ? Colors.red
                          : Colors.transparent, // Border color
                      width: 10.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Border radius
                  ),
                  child: controller.isCameraInitialized
                      ? CameraPreview(controller.cameraController)
                      : const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF8471F5)),
                          ),
                        )),
              Positioned(
                left: 16, // Ajusta la posición izquierda según sea necesario
                bottom: 16, // Ajusta la posición inferior según sea necesario
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_upward, color: Colors.white),
                        onPressed: () {
                          // Lógica para el botón de flecha hacia arriba
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward,
                            color: Colors.white),
                        onPressed: () {
                          // Lógica para el botón de flecha hacia abajo
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(
                    1, 1), // Ajusta la posición inferior según sea necesario
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica para el botón "Deshierbar"
                  },
                  child: const Text("Deshierbar"),
                ),
              ),
              controller.lettuceInSight
                  ? Align(
                      alignment: const Alignment(0, 0.9),
                      child: Container(
                        height: 80,
                        width: 200,
                        alignment: const Alignment(0, 0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(10.0), // Border radius
                        ),
                        child: const Text(
                          'Cuidado, Se ha detectado una Lechuga en rango de corte',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ))
                  : const SizedBox(),
            ],
          );
        });
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
