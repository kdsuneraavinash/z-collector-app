import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';

class ProjectListCard extends StatelessWidget {
  final String projectId;
  final Project project;

  const ProjectListCard({
    Key? key,
    required this.projectId,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Beamer.of(context).beamToNamed('/home/project/$projectId');
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primary.withAlpha(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(project.description,
                      textAlign: TextAlign.justify,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
