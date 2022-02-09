import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/views/home.dart';
import 'package:z_collector_app/views/login.dart';
import 'package:z_collector_app/views/records/add_record.dart';
import 'package:z_collector_app/views/register.dart';

class AppRouter {
  static routerDelegate(String initialPath) {
    return BeamerDelegate(
      initialPath: initialPath,
      locationBuilder: RoutesLocationBuilder(
        routes: {
          '/home': (context, state, data) => const HomePage(),
          '/login': (context, state, data) => const LoginPage(),
          '/register': (context, state, data) => const RegisterPage(),
          '/project/:projectId/records/add': (context, state, data) {
            final projectId = state.pathParameters['projectId']!;
            return BeamPage(
              key: ValueKey(projectId),
              title: projectId,
              popToNamed: '/',
              child: AddRecordPage(projectId: projectId),
            );
          }
        },
      ),
    );
  }
}
