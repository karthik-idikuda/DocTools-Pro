import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/utils/file_utils.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/document_model.dart';
import '../../services/file_service.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DatabaseHelper databaseHelper;
  final FileService fileService;

  DocumentRepositoryImpl({
    required this.databaseHelper,
    required this.fileService,
  });

  @override
  Future<Either<Failure, List<Document>>> getAllDocuments() async {
    try {
      final docs = await databaseHelper.getAllDocuments();
      return Right(docs);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Document>>> getRecentDocuments() async {
    try {
      final docs = await databaseHelper.getRecentDocuments(20);
      return Right(docs);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Document>> importFile(File file) async {
    try {
      // 1. Copy to Originals
      final result = await fileService.importToOriginals(file);

      return result.fold(
        (failure) => Left(failure),
        (savedFile) async {
          // 2. Create Document Entity
          final id = FileUtils.generateUniqueId();
          final type = _determineType(savedFile.path);
          final stat = await savedFile.stat();

          final docModel = DocumentModel(
            id: id,
            path: savedFile.path,
            name: savedFile.path.split('/').last, // Simple basename
            type: type,
            sizeBytes: stat.size,
            createdAt: DateTime.now(),
            modifiedAt: DateTime.now(),
            pageCount: 0, // Todo: Parse PDF page count
            checksum: null, // Todo: Calculate checksum
          );

          // 3. Save to Index (DB)
          await databaseHelper.insertDocument(docModel);
          return Right(docModel);
        },
      );
    } catch (e) {
      return Left(FileSystemFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String id) async {
    try {
      // For now, we only delete from DB and maybe move file to Trash
      // Real implementation should soft-delete
      await databaseHelper.deleteDocument(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  DocumentType _determineType(String path) {
    if (path.toLowerCase().endsWith('.pdf')) return DocumentType.pdf;
    if (path.toLowerCase().endsWith('.docx') ||
        path.toLowerCase().endsWith('.doc')) {
      return DocumentType.docx;
    }
    return DocumentType.image; // default/fallback
  }
}
