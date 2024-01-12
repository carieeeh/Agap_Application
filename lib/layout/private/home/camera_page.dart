import 'package:agap_mobile_v01/services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final SettingService _settingService = Get.find<SettingService>();
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      _settingService.cameras.first,
      ResolutionPreset.max,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(_controller),
    );
  }
}
