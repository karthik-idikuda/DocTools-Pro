import 'dart:io';
import 'dart:ui'; // For Rect/Size
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as path;
import 'file_service.dart';

class PDFGenerationService {
  final FileService fileService;

  PDFGenerationService({required this.fileService});

  Future<File> createPdfFromImages(List<File> images) async {
    final PdfDocument document = PdfDocument();

    for (final image in images) {
      final imageBytes = await image.readAsBytes();
      final PdfBitmap bitmap = PdfBitmap(imageBytes);

      document.pageSettings.margins.all = 0;
      // Syncfusion PDF size is Size (ui), not PdfPageSize class constructor sometimes depending on version
      // or we use standard sizes.
      // Correct usage: document.pageSettings.size = Size(width, height);
      document.pageSettings.size =
          Size(bitmap.width.toDouble(), bitmap.height.toDouble());
      document.pageSettings.orientation = PdfPageOrientation.portrait;

      final PdfPage page = document.pages.add();
      page.graphics.drawImage(
        bitmap,
        Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height),
      );
    }

    // Save to Temp
    final List<int> bytes = await document.save();
    document.dispose();

    final tempDir = await fileService.getTempDir();
    final fileName = 'SCAN_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(path.join(tempDir.path, fileName));
    await file.writeAsBytes(bytes);

    return file;
  }
}
