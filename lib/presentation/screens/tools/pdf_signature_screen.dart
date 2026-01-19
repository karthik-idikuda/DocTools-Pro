import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PDFSignatureScreen extends StatefulWidget {
  const PDFSignatureScreen({super.key});

  @override
  State<PDFSignatureScreen> createState() => _PDFSignatureScreenState();
}

class _PDFSignatureScreenState extends State<PDFSignatureScreen> {
  String? _selectedFile;
  final List<Offset> _signaturePoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign PDF'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _signaturePoints.clear()),
            tooltip: 'Clear Signature',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.upload_file, color: AppTheme.primaryGreen),
                title: Text(_selectedFile ?? 'Select PDF File'),
                subtitle: const Text('Tap to choose a file'),
                onTap: () {
                  setState(() => _selectedFile = 'document.pdf');
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text('Draw your signature:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppTheme.primaryGreen, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox box = context.findRenderObject() as RenderBox;
                      _signaturePoints.add(box.globalToLocal(details.globalPosition));
                    });
                  },
                  onPanEnd: (_) {
                    _signaturePoints.add(Offset.infinite); // Separator for strokes
                  },
                  child: CustomPaint(
                    painter: _SignaturePainter(_signaturePoints),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selectedFile != null && _signaturePoints.isNotEmpty ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signature applied to PDF!')),
                );
                Navigator.pop(context);
              } : null,
              icon: const Icon(Icons.check),
              label: const Text('Apply Signature'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;
  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
