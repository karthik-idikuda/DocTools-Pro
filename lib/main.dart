import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'presentation/providers/document_provider.dart';
import 'presentation/providers/auth_provider.dart' as auth_prov;
import 'presentation/screens/home/home_screen.dart';
import 'services/ad_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await AdHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.sl<DocumentProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<auth_prov.AuthProvider>(),
        ),
      ],
      child: MaterialApp(
        title: 'DocTools Pro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
