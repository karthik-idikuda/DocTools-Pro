import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/scanner_provider.dart';
import '../../../injection_container.dart' as di;

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScannerProvider>(
      create: (_) => di.sl<ScannerProvider>()..initCamera(),
      child: const _ScanScreenContent(),
    );
  }
}

class _ScanScreenContent extends StatelessWidget {
  const _ScanScreenContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScannerProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Preview
          if (provider.cameraController != null &&
              provider.cameraController!.value.isInitialized)
            SizedBox(
              height: size.height,
              width: size.width,
              child: CameraPreview(provider.cameraController!),
            )
          else
            const Center(child: CircularProgressIndicator()),

          // 2. Controls Overlay
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        '${provider.capturedImages.length} Pages',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flash_off, color: Colors.white),
                        onPressed: () {}, // Toggle flash
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Thumbnails
                if (provider.capturedImages.isNotEmpty)
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.capturedImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => provider.cropImage(index),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppTheme.primaryGreen, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    provider.capturedImages[index],
                                    width: 60,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -4,
                                top: -4,
                                child: InkWell(
                                  onTap: () => provider.deleteImage(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.remove_circle,
                                        color: Colors.red, size: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 20),

                // Bottom Actions
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery / Folder
                      IconButton(
                        icon: const Icon(Icons.photo_library,
                            color: Colors.white, size: 30),
                        onPressed: () {},
                      ),

                      // Capture Button
                      GestureDetector(
                        onTap: () => provider.captureImage(),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Done Button
                      IconButton(
                        icon: const Icon(Icons.check_circle,
                            color: Colors.white, size: 40),
                        onPressed: provider.capturedImages.isEmpty
                            ? null
                            : () async {
                                final success = await provider.finishScan();
                                if (success && context.mounted) {
                                  Navigator.pop(context); // Go back to home
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (provider.isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
