import 'package:flutter/foundation.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/entities/document.dart';

class FileManagerProvider with ChangeNotifier {
  final DocumentRepository repository;

  List<Document> _documents = [];
  bool _isLoading = false;

  FileManagerProvider({required this.repository});

  List<Document> get documents => _documents;
  bool get isLoading => _isLoading;

  Future<void> loadFiles() async {
    _isLoading = true;
    notifyListeners();

    final result = await repository.getAllDocuments();
    result.fold(
      (failure) => null, // Handle error
      (docs) => _documents = docs,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteFile(String id) async {
    await repository.deleteDocument(id);
    _documents.removeWhere((doc) => doc.id == id);
    notifyListeners();
  }
}
