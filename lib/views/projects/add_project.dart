import 'package:flutter/material.dart';
import 'package:z_collector_app/views/projects/add_project_stepper.dart';

class AddProjectPage extends StatelessWidget {
  const AddProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Project")),
      body: const AddProjectStepper(),
    );
  }
}
