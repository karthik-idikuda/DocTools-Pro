import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class FileService {
  Directory? _appDocDir;

  Future<void> init() async {
    _appDocDir = await getApplicationDocumentsDirectory();
    await _createDirIfNotExists(AppConstants.originalsDir);
    await _createDirIfNotExists(AppConstants.workingDir);
    await _createDirIfNotExists(AppConstants.outputDir);
    await _createDirIfNotExists(AppConstants.tempDir);
    await _createDirIfNotExists(AppConstants.trashDir);
  }

  Future<Directory> _getDir(String dirName) async {
    if (_appDocDir == null) await init();
    return Directory(path.join(_appDocDir!.path, dirName));
  }

  Future<void> _createDirIfNotExists(String dirName) async {
    final dir = Directory(path.join(_appDocDir!.path, dirName));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Copies an external file to the 'Originals' directory (Immutable)
  Future<Either<Failure, File>> importToOriginals(File sourceFile) async {
    try {
      final originalsDir = await _getDir(AppConstants.originalsDir);
      final fileName = path.basename(sourceFile.path);
      // Ensure unique name to prevent overwrites
      final uniqueName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final newPath = path.join(originalsDir.path, uniqueName);

      final savedFile = await sourceFile.copy(newPath);
      return Right(savedFile);
    } catch (e) {
      return Left(FileSystemFailure('Failed to import file: $e'));
    }
  }

  /// Creates a copy in 'Working' directory for processing
  Future<Either<Failure, File>> createWorkingCopy(File originalFile) async {
    try {
      final workingDir = await _getDir(AppConstants.workingDir);
      final fileName = path.basename(originalFile.path);
      final newPath = path.join(workingDir.path,
          'JOB_${DateTime.now().millisecondsSinceEpoch}_$fileName');

      final workingFile = await originalFile.copy(newPath);
      return Right(workingFile);
    } catch (e) {
      return Left(FileSystemFailure('Failed to create working copy: $e'));
    }
  }

  /// Atomic Write: Moves file from Temp to Output
  Future<Either<Failure, File>> moveToOutput(File tempFile,
      {String? desiredName}) async {
    try {
      final outputDir = await _getDir(AppConstants.outputDir);
      final fileName = desiredName ?? path.basename(tempFile.path);
      final newPath = path.join(outputDir.path, fileName);

      // Atomic rename (mostly atomic on POSIX)
      final outputFile = await tempFile.rename(newPath);
      return Right(outputFile);
    } catch (e) {
      return Left(FileSystemFailure('Failed to move to output: $e'));
    }
  }

  Future<Directory> getTempDir() async {
    return _getDir(AppConstants.tempDir);
  }

  Future<void> cleanTemp() async {
    try {
      final tempDir = await _getDir(AppConstants.tempDir);
      if (await tempDir.exists()) {
        tempDir.listSync().forEach((FileSystemEntity entity) {
          try {
            entity.deleteSync(recursive: true);
          } catch (e) {
            // Ignore individual delete errors
          }
        });
      }
    } catch (e) {
      // Ignore directory access errors
    }
  }
}
