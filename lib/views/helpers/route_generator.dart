import 'package:flutter/material.dart';
import 'package:z_collector_app/views/home.dart';
import 'package:z_collector_app/views/login.dart';
import 'package:z_collector_app/views/records/add_record.dart';
import 'package:z_collector_app/views/register.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: generatePageBuilder(settings));
  }

  static WidgetBuilder generatePageBuilder(RouteSettings settings) {
    final args = settings.arguments ?? [];
    if (args is! List) {
      return (_) => const LoginPage();
    }

    switch (settings.name) {
      case '/home':
        return (_) => const HomePage();
      case '/register':
        return (_) => const RegisterPage();
      case '/records/add':
        return (_) => AddRecordPage(projectId: args[0]);
      default:
        return (_) => const LoginPage();
    }
  }
}
