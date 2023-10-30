import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EdgeDetectionSample(),
    );
  }
}

class EdgeDetectionSample extends StatefulWidget {
  const EdgeDetectionSample({Key? key}) : super(key: key);

  @override
  State<EdgeDetectionSample> createState() => _EdgeDetectionSampleState();
}

class _EdgeDetectionSampleState extends State<EdgeDetectionSample> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestPermissions();
    });
  }

  Future<void> requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> getImage() async {
    String? imagePath;

    try {
      imagePath = EdgeDetection.detectEdge as String?;
    } on PlatformException catch (e) {
      imagePath = e.toString();
    }

    setState(() {
      _imagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EdgeDetection Sample'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: getImage,
                child: const Text('Scan'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Cropped image path:'),
            Text(
              _imagePath ?? 'No image path',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            Visibility(
              visible: _imagePath != null && _imagePath!.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.file(
                  File(_imagePath!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
