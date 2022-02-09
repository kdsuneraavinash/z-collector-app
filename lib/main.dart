import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/helpers/route_generator.dart';
import 'package:z_collector_app/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:z_collector_app/views/login.dart';
import 'package:z_collector_app/views/records/add_record.dart';
import 'package:z_collector_app/views/register.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final loggedInUser = await FirebaseAuth.instance.userChanges().first;
  runApp(MyApp(loggedIn: loggedInUser != null));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;

  const MyApp({Key? key, required this.loggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          FormBuilderLocalizations.delegate,
        ],
        title: 'Z-Collector',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: loggedIn ? '/home' : '/login',
      ),
    );
  }
}
