import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/document_repository.dart';
import '../../services/pdf_service.dart';

class PDFToolsProvider with ChangeNotifier {
  final PDFService pdfService;
  final DocumentRepository documentRepository;

  bool _isProcessing = false;
  String? _error;
  List<File> _selectedFiles = [];

  PDFToolsProvider({
    required this.pdfService,
    required this.documentRepository,
  });

  bool get isProcessing => _isProcessing;
  String? get error => _error;
  List<File> get selectedFiles => _selectedFiles;

  void clearFiles() {
    _selectedFiles = [];
    notifyListeners();
  }

  Future<void> pickFiles() async {
    _error = null;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null) {
        // Filter valid files
        _selectedFiles = result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error picking files: $e';
      notifyListeners();
    }
  }

  Future<bool> mergeSelectedFiles() async {
    if (_selectedFiles.length < 2) {
      _error = "Select at least 2 files";
      notifyListeners();
      return false;
    }

    _isProcessing = true;
    _error = null;
    notifyListeners();

    final result = await pdfService.mergePDFs(_selectedFiles);

    return result.fold(
      (failure) {
        _error = failure.message;
        _isProcessing = false;
        notifyListeners();
        return false;
      },
      (mergedFile) async {
        // Save to DB/Originals
        final importResult = await documentRepository.importFile(mergedFile);
        _isProcessing = false;
        clearFiles();
        notifyListeners();
        return importResult.isRight();
      },
    );
  }

  Future<void> removeFile(int index) async {
    if (index >= 0 && index < _selectedFiles.length) {
      _selectedFiles.removeAt(index);
      notifyListeners();
    }
  }
}
