import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class PDFCompressScreen extends StatelessWidget {
  const PDFCompressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Compress UI
    return Scaffold(
      appBar: AppBar(title: const Text('Compress PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Choose Compression Level",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildOption("High Quality (Low Compression)"),
            _buildOption("Balanced"),
            _buildOption("Low Quality (High Compression)"),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                // Mock action
                final res = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['pdf']);
                if (res != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Compressed Successfully (Mock)")));
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Select PDF to Compress"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String text) {
    return Card(
      child: ListTile(
        title: Text(text),
        leading: Radio<String>(
          value: text,
          // ignore: deprecated_member_use
          groupValue: "Balanced",
          // ignore: deprecated_member_use
          onChanged: (_) {},
        ),
      ),
    );
  }
}
