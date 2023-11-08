import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weeding_bot/models/object_model.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  List<ObjectModel> allObjects = [];
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false;
  var cameraCount = 0;
  var detectorBusy = false;
  final double threshold = 0.5;

  bool lettuceInSight = false;
  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
        });
        update();
      });
      isCameraInitialized = true;
      update();
    } else {
      debugPrint("Permission to access camera is not granted by user");
    }
    update();
  }


  objectDetectorFromWS(Stream<CameraImage> imageStream) {
    imageStream.listen((frame) async {
      try {
        if (detectorBusy) {
          debugPrint("Detector is busy, skipping");
          return;
        }
        detectorBusy = true;
        var detector = await Tflite.runModelOnFrame(
          bytesList: frame.planes.map((e) {
            return e.bytes;
          }).toList(),
          imageHeight: frame.height,
          imageWidth: frame.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 0,
          numResults: 5,
          threshold: 0.1,
        );

        if (detector != null) {
          bool lettuceAux = false;
          for (var obj in detector) {
            if (obj['label'] == "1 lettuce") {
              debugPrint("uwu");
              lettuceAux = true;
              debugPrint('$detector');
            }
          }
          if (lettuceAux) {
            lettuceInSight = true;
          } else {
            lettuceInSight = false;
          }
          update();
        }
      } catch (e) {
        debugPrint("$e");
      } finally {
        detectorBusy = false;
      }
    });
  }

  objectDetector(CameraImage frame) async {
    try {
      if (detectorBusy) {
        debugPrint("detector is busy, skiping");
        return;
      }
      detectorBusy = true;
      var detector = await Tflite.runModelOnFrame(
          bytesList: frame.planes.map((e) {
            return e.bytes;
          }).toList(),
          imageHeight: frame.height,
          imageWidth: frame.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 0,
          numResults: 5,
          threshold: 0.1);

      if (detector != null) {
        bool lettuceAux = false;
        for (var obj in detector) {
          if (obj['label'] == "1 lettuce") {
            debugPrint("uwu");
            lettuceAux = true;
            debugPrint('$detector');
          }
        }
        if (lettuceAux) {
          lettuceInSight = true;
        } else {
          lettuceInSight = false;
        }
        update();
      }
    } catch (e) {
      debugPrint("$e");
    } finally {
      detectorBusy = false;
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: "assets/trainedModel/weedDetector.tflite",
      labels: "assets/trainedModel/labels.txt",
    );
  }
}
