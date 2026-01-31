import 'package:flutter/material.dart';
import 'app.dart';
import 'injection_container.dart' as di;
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  // Initialize dependency injection
  await di.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations', // folder path
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ),
  );
}
