import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/helpers/firebase_builders.dart';
import 'package:z_collector_app/views/projects/list_card.dart';

class HomeProjectListSection extends StatelessWidget {
  final String title;
  final String path;
  final int max;
  final Query<Map<String, dynamic>> query;

  const HomeProjectListSection({
    Key? key,
    required this.title,
    required this.path,
    required this.query,
    this.max = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.headline6),
              TextButton(
                onPressed: () => Beamer.of(context).beamToNamed(path),
                child: Row(
                  children: const [
                    Text('View All'),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
          FirestoreQueryStreamBuilder(
            isList: false,
            emptyWidget: const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Nothing to show."),
            ),
            stream: query.limit(max).snapshots(),
            builder: (context, projectId, projectMap) {
              final project = Project.fromJson(projectMap);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ProjectListCard(
                  projectId: projectId,
                  project: project,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
