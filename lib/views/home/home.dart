import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeProjectListSection(
              title: "My Projects",
              path: '/home/list/project/my',
              query: getMyProjects(),
            ),
            const SizedBox(height: 8),
            HomeProjectListSection(
              title: "Private Projects",
              path: '/home/list/project/private',
              query: getPrivateProjects(),
            ),
            const SizedBox(height: 8),
            HomeProjectListSection(
              title: "Public Projects",
              path: '/home/list/project/public',
              max: 3,
              query: getPublicProjects(),
            ),
          ],
        ),
      ),
    );
  }
}
