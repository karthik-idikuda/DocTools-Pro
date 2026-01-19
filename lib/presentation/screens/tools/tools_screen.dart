import 'package:flutter/material.dart';
import 'pdf_merge_screen.dart';
import 'pdf_split_screen.dart';
import 'pdf_compress_screen.dart';
import 'pdf_rotate_screen.dart';
import 'pdf_delete_pages_screen.dart';
import 'pdf_signature_screen.dart';
import 'pdf_reorder_screen.dart';
import '../../../core/theme/app_theme.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {'icon': Icons.merge_type, 'label': 'Merge', 'desc': 'Combine PDFs', 'route': const PDFMergeScreen()},
      {'icon': Icons.call_split, 'label': 'Split', 'desc': 'Extract pages', 'route': const PDFSplitScreen()},
      {'icon': Icons.compress, 'label': 'Compress', 'desc': 'Reduce size', 'route': const PDFCompressScreen()},
      {'icon': Icons.rotate_right, 'label': 'Rotate', 'desc': 'Rotate pages', 'route': const PDFRotateScreen()},
      {'icon': Icons.delete_outline, 'label': 'Delete', 'desc': 'Remove pages', 'route': const PDFDeletePagesScreen()},
      {'icon': Icons.reorder, 'label': 'Reorder', 'desc': 'Rearrange', 'route': const PDFReorderScreen()},
      {'icon': Icons.draw, 'label': 'Sign', 'desc': 'Add signature', 'route': const PDFSignatureScreen()},
      {'icon': Icons.picture_as_pdf, 'label': 'DOCX→PDF', 'desc': 'Convert docs', 'route': null},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Tools'),
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: Container(
        color: AppTheme.backgroundWhite,
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return _buildToolCard(context, tool);
          },
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, Map<String, dynamic> tool) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: tool['route'] == null
              ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Coming Soon")))
              : () => Navigator.push(context, MaterialPageRoute(builder: (_) => tool['route'] as Widget)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(tool['icon'] as IconData, size: 28, color: AppTheme.primaryGreen),
                ),
                const SizedBox(height: 12),
                Text(
                  tool['label'] as String,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  tool['desc'] as String,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
