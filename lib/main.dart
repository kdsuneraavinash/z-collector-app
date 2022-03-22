import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:z_collector_app/views/home/home.dart';
import 'package:z_collector_app/views/login.dart';
import 'package:z_collector_app/views/projects/detail_project.dart';
import 'package:z_collector_app/views/projects/add_project.dart';
import 'package:z_collector_app/views/projects/lists.dart';
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
  late final BeamerDelegate routerDelegate;

  MyApp({Key? key, required this.loggedIn}) : super(key: key) {
    routerDelegate = BeamerDelegate(
      initialPath: loggedIn ? '/home' : '/login',
      locationBuilder: RoutesLocationBuilder(
        routes: {
          '/login': (context, state, data) => const LoginPage(),
          '/register': (context, state, data) => const RegisterPage(),
          '/home': (context, state, data) => const HomePage(),
          '/home/add/project': (context, state, data) => const AddProjectPage(),
          '/home/list/project/my': (context, state, data) =>
              const ListMyProjects(),
          '/home/list/project/private': (context, state, data) =>
              const ListPrivateProjects(),
          '/home/list/project/public': (context, state, data) =>
              const ListPublicProjects(),
          '/home/project/:projectId': (context, state, data) {
            final projectId = state.pathParameters['projectId']!;
            return BeamPage(
              key: ValueKey('details$projectId'),
              title: projectId,
              popToNamed: '/home',
              child: DetailProjectPage(projectId: projectId),
            );
          },
          '/home/project/:projectId/record/add': (context, state, data) {
            final projectId = state.pathParameters['projectId']!;
            return BeamPage(
              key: ValueKey('recordAdd$projectId'),
              title: projectId,
              popToNamed: '/home/project/$projectId',
              child: AddRecordPage(projectId: projectId),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          FormBuilderLocalizations.delegate,
        ],
        title: 'Z-Collector',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            secondary: Colors.orangeAccent,
          ),
          useMaterial3: true,
        ),
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        backButtonDispatcher:
            BeamerBackButtonDispatcher(delegate: routerDelegate),
      ),
    );
  }
}
