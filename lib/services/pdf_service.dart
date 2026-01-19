import 'dart:io';
import 'dart:ui'; // For Offset
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as path;
import 'package:dartz/dartz.dart';
import '../core/error/failures.dart';
import 'file_service.dart';

class PDFService {
  final FileService fileService;

  PDFService({required this.fileService});

  /// Merge multiple PDFs into one
  Future<Either<Failure, File>> mergePDFs(List<File> files) async {
    try {
      final PdfDocument document = PdfDocument();

      for (final file in files) {
        final PdfDocument inputDoc =
            PdfDocument(inputBytes: file.readAsBytesSync());
        // Import all pages
        for (int i = 0; i < inputDoc.pages.count; i++) {
          // Templates are better but simpler is to use importPage which syncfusion supports?
          // Syncfusion has PdfDocument.merge() functionality but it might be strictly static or via manual page copying.
          // Let's use PdfDocument.importPage
          document.pages.add().graphics.drawPdfTemplate(
                inputDoc.pages[i].createTemplate(),
                const Offset(0, 0),
              );
        }
        inputDoc.dispose();
      }

      final bytes = await document.save();
      document.dispose();

      final tempDir = await fileService.getTempDir();
      final file = File(path.join(
          tempDir.path, 'MERGED_${DateTime.now().millisecondsSinceEpoch}.pdf'));
      await file.writeAsBytes(bytes);

      return Right(file);
    } catch (e) {
      return Left(PDFProcessingFailure(e.toString()));
    }
  }

  /// Split PDF - Extract specific pages
  Future<Either<Failure, File>> splitPDF(
      File file, List<int> pageIndices) async {
    try {
      final PdfDocument inputDoc =
          PdfDocument(inputBytes: await file.readAsBytes());
      final PdfDocument outputDoc = PdfDocument();

      // indices are 0-based
      for (final index in pageIndices) {
        if (index >= 0 && index < inputDoc.pages.count) {
          outputDoc.pages.add().graphics.drawPdfTemplate(
                inputDoc.pages[index].createTemplate(),
                const Offset(0, 0),
              );
        }
      }

      inputDoc.dispose();
      final bytes = await outputDoc.save();
      outputDoc.dispose();

      final tempDir = await fileService.getTempDir();
      final outFile = File(path.join(
          tempDir.path, 'SPLIT_${DateTime.now().millisecondsSinceEpoch}.pdf'));
      await outFile.writeAsBytes(bytes);

      return Right(outFile);
    } catch (e) {
      return Left(PDFProcessingFailure(e.toString()));
    }
  }

  /// Compress PDF (Basic optimization)
  Future<Either<Failure, File>> compressPDF(File file) async {
    try {
      final PdfDocument inputDoc =
          PdfDocument(inputBytes: await file.readAsBytes());

      // Enable compression options
      inputDoc.compressionLevel = PdfCompressionLevel.best;

      // Optionally removed metadata in new document copy if needed,
      // but strictly saving with 'best' compression might help.
      // Re-saving usually optimizes.

      final bytes = await inputDoc.save();
      inputDoc.dispose();

      final tempDir = await fileService.getTempDir();
      final outFile = File(path.join(tempDir.path,
          'COMPRESSED_${DateTime.now().millisecondsSinceEpoch}.pdf'));
      await outFile.writeAsBytes(bytes);

      return Right(outFile);
    } catch (e) {
      return Left(PDFProcessingFailure(e.toString()));
    }
  }
}
