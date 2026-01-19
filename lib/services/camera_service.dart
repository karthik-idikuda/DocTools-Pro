import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // Use the first back-facing camera
    final firstCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
  }

  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }
    if (_controller!.value.isTakingPicture) {
      return null;
    }

    try {
      return await _controller!.takePicture();
    } catch (e) {
      // Handle camera exception
      return null;
    }
  }

  void dispose() {
    _controller?.dispose();
  }

  CameraController? get controller => _controller;
}
