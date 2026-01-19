import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:dartz/dartz.dart';
import '../core/error/failures.dart';

class OCRService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<Either<Failure, String>> extractText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);
      return Right(recognizedText.text);
    } catch (e) {
      return Left(OCRFailure(e.toString()));
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
