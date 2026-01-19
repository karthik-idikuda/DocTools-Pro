import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/document_repository.dart';

class DocumentProvider with ChangeNotifier {
  final DocumentRepository repository;

  List<Document> _recentDocuments = [];
  bool _isLoading = false;
  String? _error;

  DocumentProvider({required this.repository});

  List<Document> get recentDocuments => _recentDocuments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRecentDocuments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await repository.getRecentDocuments();

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (documents) {
        _recentDocuments = documents;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> importFile(File file) async {
    _isLoading = true;
    notifyListeners();

    final result = await repository.importFile(file);

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (newDoc) {
        _recentDocuments.insert(0, newDoc);
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
