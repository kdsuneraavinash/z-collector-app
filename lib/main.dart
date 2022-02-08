import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:z_collector_app/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:z_collector_app/views/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      title: 'Z-Collector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
