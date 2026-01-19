import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class FileUtils {
  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (bytes.toString().length - 1) ~/ 3; // Log10-ish approximation
    // A more precise log calculation would be better but this is sufficient for UI
    if (i >= suffixes.length) i = suffixes.length - 1;
    // double size = bytes / pow(1024, i);
    // Simplified logic for brevity without pow import

    // Let's use standard loops or just trust a simpler logic if precision isn't critical
    // Or just simple math:
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(decimals)} KB";
    }
    if (bytes < 1024 * 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(decimals)} MB";
    }
    return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(decimals)} GB";
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  static String generateUniqueId() {
    return const Uuid().v4();
  }

  static String generateFileName(String prefix, String extension) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    return '${prefix}_${formatter.format(now)}.$extension';
  }
}
