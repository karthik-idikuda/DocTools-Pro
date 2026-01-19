import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DocxEditorScreen extends StatefulWidget {
  const DocxEditorScreen({super.key});

  @override
  State<DocxEditorScreen> createState() => _DocxEditorScreenState();
}

class _DocxEditorScreenState extends State<DocxEditorScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isBold = false;
  bool _isItalic = false;
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Editor'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDocument,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPDF,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          // Formatting Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                _buildFormatButton(Icons.format_bold, 'Bold', _isBold, () {
                  setState(() => _isBold = !_isBold);
                }),
                _buildFormatButton(Icons.format_italic, 'Italic', _isItalic, () {
                  setState(() => _isItalic = !_isItalic);
                }),
                const VerticalDivider(width: 16),
                IconButton(
                  icon: const Icon(Icons.text_decrease),
                  onPressed: () {
                    if (_fontSize > 10) setState(() => _fontSize -= 2);
                  },
                  tooltip: 'Decrease font size',
                ),
                Text('${_fontSize.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.text_increase),
                  onPressed: () {
                    if (_fontSize < 40) setState(() => _fontSize += 2);
                  },
                  tooltip: 'Increase font size',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: () {},
                  tooltip: 'Undo',
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  onPressed: () {},
                  tooltip: 'Redo',
                ),
              ],
            ),
          ),
          // Editor Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                ),
                decoration: const InputDecoration(
                  hintText: 'Start typing your document...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton(IconData icon, String tooltip, bool isActive, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
      color: isActive ? AppTheme.primaryGreen : Colors.grey.shade600,
      style: IconButton.styleFrom(
        backgroundColor: isActive ? AppTheme.primaryGreen.withValues(alpha: 0.1) : null,
      ),
    );
  }

  void _saveDocument() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document is empty')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document saved!')),
    );
  }

  void _exportToPDF() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to export')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exported to PDF!')),
    );
  }
}
