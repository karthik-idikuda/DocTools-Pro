import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/document.dart';

abstract class DocumentRepository {
  Future<Either<Failure, List<Document>>> getRecentDocuments();
  Future<Either<Failure, List<Document>>> getAllDocuments();
  Future<Either<Failure, Document>> importFile(File file);
  Future<Either<Failure, void>> deleteDocument(String id);
}
