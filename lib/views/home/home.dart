import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/views/helpers/firebase_builders.dart';
import 'package:z_collector_app/views/helpers/get_projects.dart';
import 'package:z_collector_app/views/home/list_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Z- Collector"),
      ),
      body: FirebaseUserStreamBuilder(
        builder: (context, currentUserId) => SingleChildScrollView(
          child: Column(
            children: [
              HomeProjectListSection(
                title: "My Projects",
                path: '/home/my-projects',
                query: getMyProjects(currentUserId),
              ),
              const SizedBox(height: 8),
              HomeProjectListSection(
                title: "Private Projects",
                path: '/home/private-projects',
                query: getPrivateProjects(currentUserId),
              ),
              const SizedBox(height: 8),
              HomeProjectListSection(
                title: "Public Projects",
                path: '/home/public-projects',
                max: 3,
                query: getPublicProjects(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Beamer.of(context).beamToNamed('/home/add-project');
        },
        label: const Text("Add Project"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
