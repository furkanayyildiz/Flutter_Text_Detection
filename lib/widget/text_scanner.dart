import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_recognition/screen/result_screen.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class TextScanner extends StatefulWidget {
  final int point;
  const TextScanner({Key? key, required this.point}) : super(key: key);

  @override
  State<TextScanner> createState() => _TextScannerState();
}

class _TextScannerState extends State<TextScanner> with WidgetsBindingObserver {
  bool isPermissionTaken = false;
  late final Future<void> future;

  CameraController? cameraController;
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    future = requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    // kameradan kapatılacağında
    if (state == AppLifecycleState.inactive) {
      stopCamera();
    }
    // kamera açıldığında
    else if (state == AppLifecycleState.resumed &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return Stack(
            children: [
              if (isPermissionTaken)
                FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        initialiseCameraController(snapshot.data!);
                        return Center(
                          child: CameraPreview(cameraController!),
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    }),
              Scaffold(
                appBar: AppBar(
                  title: const Text('Text Recognition Sample'),
                ),
                backgroundColor: isPermissionTaken ? Colors.transparent : null,
                body: isPermissionTaken
                    ? Column(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            padding: EdgeInsets.only(bottom: 30),
                            child: ElevatedButton(
                                onPressed: () {
                                  scanImage();
                                },
                                child: Text('Scan Text')),
                          ),
                        ],
                      )
                    : Center(
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: const Text(
                            'Camera Permission Denied',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ),
            ],
          );
        });
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      isPermissionTaken = true;
    } else {
      isPermissionTaken = false;
    }
  }

  void initialiseCameraController(List<CameraDescription> cameras) {
    if (cameraController != null) {
      return;
    }
    //Select the first ream camera
    CameraDescription? camera;
    for (var a = 0; a < cameras.length; a++) {
      final CameraDescription current = cameras[a];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }
    if (camera != null) {
      cameraSelected(camera);
    }
  }

  Future<void> cameraSelected(CameraDescription camera) async {
    cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await cameraController?.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void startCamera() {
    if (cameraController != null) {
      cameraSelected(cameraController!.description);
    }
  }

  void stopCamera() {
    if (cameraController != null) {
      cameraController?.dispose();
    }
  }

  Future<void> scanImage() async {
    if (cameraController == null) {
      return;
    }
    final navigator = Navigator.of(context);
    try {
      final pictureFile = await cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizerText = await textRecognizer.processImage(inputImage);
      await navigator.push(
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(text: recognizerText.text, point: widget.point),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }
}
