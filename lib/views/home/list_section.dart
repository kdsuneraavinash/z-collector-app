import 'dart:math';

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
  final Future<QuerySnapshot<Map<String, dynamic>>> query;

  const HomeProjectListSection({
    Key? key,
    required this.title,
    required this.path,
    required this.query,
    this.max = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          FirestoreTBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: query,
            builder: (context, snapshot) {
              final allItems = snapshot.docs.toList();
              final items = allItems.sublist(0, min(max, allItems.length));
              final itemWidgets = items.map((doc) {
                final proj = Project.fromJson(doc.data());
                return ProjectListCard(
                    title: proj.name,
                    description: proj.description,
                    imageUrl: proj.imageUrl,
                    projectId: doc.id);
              }).toList();

              final hasMoreButton = allItems.length > max;

              return Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    hasMoreButton
                        ? TextButton(
                            onPressed: () {
                              Beamer.of(context).beamToNamed(path);
                            },
                            child: Row(
                              children: const [
                                Text('More'),
                                Icon(Icons.chevron_right)
                              ],
                            ))
                        : Container(),
                  ],
                ),
                itemWidgets.isNotEmpty
                    ? Column(
                        children: itemWidgets,
                      )
                    : Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text("Nothing to show."),
                      ),
              ]);
            },
          ),
        ],
      ),
    );
  }
}
