import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import '../../services/camera_service.dart';
import '../../services/image_processor_service.dart';
import '../../services/file_service.dart';
import '../../domain/repositories/document_repository.dart';
import '../../services/pdf_generation_service.dart';

class ScannerProvider with ChangeNotifier {
  final CameraService cameraService;
  final ImageProcessorService imageProcessor;
  final DocumentRepository documentRepository;
  final PDFGenerationService pdfGenerationService;
  final FileService fileService;

  final List<File> _capturedImages = [];
  bool _isProcessing = false;
  String? _error; // Keep private field
  String? get error => _error; // Getter

  ScannerProvider({
    required this.cameraService,
    required this.imageProcessor,
    required this.documentRepository,
    required this.pdfGenerationService,
    required this.fileService,
  });

  List<File> get capturedImages => _capturedImages;
  bool get isProcessing => _isProcessing;
  CameraController? get cameraController => cameraService.controller;

  Future<void> initCamera() async {
    await cameraService.initialize();
    notifyListeners();
  }

  Future<void> captureImage() async {
    final xFile = await cameraService.takePicture();
    if (xFile != null) {
      // Move to temp immediately
      final file = File(xFile.path);
      // Optional: Auto crop here or manual? Let's minimal logic
      _capturedImages.add(file);
      notifyListeners();
    }
  }

  Future<void> cropImage(int index) async {
    final file = _capturedImages[index];
    final result = await imageProcessor.cropImage(file);
    result.fold(
      (failure) => null, // cancelled or error
      (croppedFile) {
        _capturedImages[index] = croppedFile;
        notifyListeners();
      },
    );
  }

  Future<void> deleteImage(int index) async {
    _capturedImages.removeAt(index);
    notifyListeners();
  }

  Future<bool> finishScan() async {
    if (_capturedImages.isEmpty) return false;
    _isProcessing = true;
    notifyListeners();

    try {
      // 1. Generate PDF
      final pdfFile =
          await pdfGenerationService.createPdfFromImages(_capturedImages);

      // 2. Import to App Ecosystem (Originals -> Index)
      final result = await documentRepository.importFile(pdfFile);

      // 3. Cleanup source images if needed?
      // Keep them in temp for a bit? No, clear them
      _capturedImages.clear();
      _isProcessing = false;

      return result.isRight();
    } catch (e) {
      _error = e.toString();
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }
}
