import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/file_service.dart';
import 'data/datasources/local/database_helper.dart';
import 'domain/repositories/document_repository.dart';
import 'data/repositories/document_repository_impl.dart';
import 'presentation/providers/document_provider.dart';
import 'presentation/providers/scanner_provider.dart';
import 'services/camera_service.dart';
import 'services/image_processor_service.dart';
import 'services/pdf_generation_service.dart';
import 'services/ocr_service.dart';
import 'presentation/providers/pdf_tools_provider.dart';
import 'presentation/providers/file_manager_provider.dart';
import 'presentation/providers/auth_provider.dart' as auth_prov;
import 'services/pdf_service.dart' as pdf;
import 'services/auth_service.dart' as auth;

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Services & Persistence
  final fileService = FileService();
  await fileService.init(); // Init directories
  sl.registerLazySingleton(() => fileService);

  final databaseHelper = DatabaseHelper();
  sl.registerLazySingleton(() => databaseHelper);

  sl.registerLazySingleton(() => CameraService());
  sl.registerLazySingleton(() => ImageProcessorService());
  sl.registerLazySingleton(() => PDFGenerationService(fileService: sl()));
  sl.registerLazySingleton(() => OCRService());
  sl.registerLazySingleton(() => pdf.PDFService(fileService: sl()));
  sl.registerLazySingleton(() => auth.AuthService());

  // Repositories
  sl.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(
      databaseHelper: sl(),
      fileService: sl(),
    ),
  );

  // Providers
  sl.registerFactory(
    () => DocumentProvider(repository: sl()),
  );

  sl.registerFactory(
    () => ScannerProvider(
      cameraService: sl(),
      imageProcessor: sl(),
      documentRepository: sl(),
      pdfGenerationService: sl(),
      fileService: sl(),
    ),
  );

  sl.registerFactory(
    () => PDFToolsProvider(
      pdfService: sl(),
      documentRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => FileManagerProvider(repository: sl()),
  );

  sl.registerFactory(
    () => auth_prov.AuthProvider(authService: sl()),
  );
}
