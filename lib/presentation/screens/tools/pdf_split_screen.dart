import 'package:flutter/material.dart';

class PDFSplitScreen extends StatelessWidget {
  const PDFSplitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simplified placeholder as full Split UI requires rendering PDF pages
    return Scaffold(
      appBar: AppBar(title: const Text('Split PDF')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.call_split, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Select Pages to Split"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Mock split action
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Split feature requires file selection")));
              },
              child: const Text("Select PDF"),
            )
          ],
        ),
      ),
    );
  }
}
