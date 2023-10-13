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
        debugPrint("result is $detector");
      } else {}
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
