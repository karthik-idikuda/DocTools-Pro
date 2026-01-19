import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/document_provider.dart';
import '../scan/scan_screen.dart';
import '../tools/tools_screen.dart';
import '../edit/docx_editor_screen.dart';
import '../file_manager/file_manager_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Simplified Home structure for Tab navigation usually requires a PageView or IndexedStack.
// Given the current structure is a single Scaffold, let's update it to switch body content.

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentProvider>().loadRecentDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only verify Home and Tools for now
    final pages = [
      const _HomeContent(), // Home (Recent)
      const ScanScreen(), // Scan (Tab)
      const DocxEditorScreen(), // Edit (Tab)
      const ToolsScreen(), // Tools (Tab)
      const FileManagerScreen(), // Map Profile to Files for now? Or keep simple. Let's start with FileManager as 5th tab or just access via Home.
      // Prompt asked for "Profile" as 5th. Let's make a placeholder Profile which links to specific actions.
    ];

    return Scaffold(
      body: pages[_currentIndex], // Direct switch
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScanScreen()),
                );
              },
              child: const Icon(Icons.camera_alt),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            // For Scan, maybe modal? or Tab. Let's keep it as Tab BUT ScanScreen has its own scaffold/provider.
            // If we put it here, we might need to adjust.
            // Let's just launch it as modal for now and keep tab as placeholder?
            // Or better, just open ScanScreen and don't change tab index?
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ScanScreen()));
            return;
          }
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.scanner), label: 'Scan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_document), label: 'Edit'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Files'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // For gradient feeling if we had transparent bar, but let's keep it simple style
      // Actually for premium look, let's make AppBar transparent/gradient
      // Premium Solid Color AppBar
      appBar: AppBar(
        title: const Text('DocTools Pro'),
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
        ],
      ),
      body: Container(
        color: AppTheme.backgroundWhite,
        child: Consumer<DocumentProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null) {
              return Center(child: Text('Error: ${provider.error}'));
            }
            if (provider.recentDocuments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: const Icon(Icons.description,
                          size: 64, color: AppTheme.primaryGreen),
                    ),
                    const SizedBox(height: 24),
                    const Text('No documents yet!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Start by scanning or importing',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Scan Document'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text("Recent Files",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGreen)),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: provider.recentDocuments.length,
                    itemBuilder: (context, index) {
                      final doc = provider.recentDocuments[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.lightGreen.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.picture_as_pdf,
                                color: AppTheme.primaryGreen),
                          ),
                          title: Text(doc.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle:
                              Text(doc.sizeBytes.toString()), // Formatting Todo
                          trailing:
                              const Icon(Icons.more_vert, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
