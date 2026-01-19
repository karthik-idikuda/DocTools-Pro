import 'package:equatable/equatable.dart';

enum DocumentType { pdf, docx, scan, image }

class Document extends Equatable {
  final String id;
  final String path;
  final String name;
  final DocumentType type;
  final int sizeBytes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int? pageCount;
  final String? checksum;
  final String? thumbnailPath;

  const Document({
    required this.id,
    required this.path,
    required this.name,
    required this.type,
    required this.sizeBytes,
    required this.createdAt,
    required this.modifiedAt,
    this.pageCount,
    this.checksum,
    this.thumbnailPath,
  });

  @override
  List<Object?> get props => [
        id,
        path,
        name,
        type,
        sizeBytes,
        createdAt,
        modifiedAt,
        pageCount,
        checksum,
        thumbnailPath
      ];
}
