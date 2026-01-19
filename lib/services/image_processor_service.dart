import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../core/error/failures.dart';

class ImageProcessorService {
  Future<Either<Failure, File>> cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        // compressQuality: 100, // Optional
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (croppedFile != null) {
        return Right(File(croppedFile.path));
      } else {
        return const Left(FileSystemFailure("Cropping cancelled"));
      }
    } catch (e) {
      return Left(FileSystemFailure(e.toString()));
    }
  }
}
