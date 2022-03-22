import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class ProjectListCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final String projectId;

  const ProjectListCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.projectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(description,
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              Beamer.of(context).beamToNamed('/home/project/$projectId');
            },
            icon: const Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}
