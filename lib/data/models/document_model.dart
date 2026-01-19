import '../../domain/entities/document.dart';

class DocumentModel extends Document {
  const DocumentModel({
    required super.id,
    required super.path,
    required super.name,
    required super.type,
    required super.sizeBytes,
    required super.createdAt,
    required super.modifiedAt,
    super.pageCount,
    super.checksum,
    super.thumbnailPath,
  });

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'],
      path: map['path'],
      name: map['name'],
      type: DocumentType.values[map['type_index']],
      sizeBytes: map['size_bytes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map['modified_at']),
      pageCount: map['page_count'],
      checksum: map['checksum'],
      thumbnailPath: map['thumbnail_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'type_index': type.index,
      'size_bytes': sizeBytes,
      'created_at': createdAt.millisecondsSinceEpoch,
      'modified_at': modifiedAt.millisecondsSinceEpoch,
      'page_count': pageCount,
      'checksum': checksum,
      'thumbnail_path': thumbnailPath,
    };
  }

  factory DocumentModel.fromEntity(Document doc) {
    return DocumentModel(
      id: doc.id,
      path: doc.path,
      name: doc.name,
      type: doc.type,
      sizeBytes: doc.sizeBytes,
      createdAt: doc.createdAt,
      modifiedAt: doc.modifiedAt,
      pageCount: doc.pageCount,
      checksum: doc.checksum,
      thumbnailPath: doc.thumbnailPath,
    );
  }
}
