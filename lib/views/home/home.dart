import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

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
          children: const [
            HomeProjectList(
                title: "My Projects", path: '/home/list/project/my'),
            SizedBox(height: 8),
            HomeProjectList(
                title: "Private Projects", path: '/home/list/project/private'),
            SizedBox(height: 8),
            HomeProjectList(
                title: "Public Projects", path: '/home/list/project/public'),
          ],
        ),
      ),
    );
  }
}

class HomeProjectList extends StatelessWidget {
  final String title;
  final String path;
  final int max;

  const HomeProjectList({
    Key? key,
    required this.title,
    required this.path,
    this.max = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                  onPressed: () {
                    Beamer.of(context).beamToNamed(path);
                  },
                  child: Row(
                    children: const [Text('More'), Icon(Icons.chevron_right)],
                  )),
            ],
          ),
          const ProjectCard(
            title: "My Project",
            description: 'Sample description',
            imageUrl: '',
            projectId: '',
          ),
          const SizedBox(height: 8),
          const ProjectCard(
            title: "My Project",
            description: 'Sample description',
            imageUrl: '',
            projectId: '',
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final String projectId;

  const ProjectCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.projectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Ink(
            decoration: const ShapeDecoration(
              color: Colors.lightBlue,
              shape: CircleBorder(),
            ),
            child: IconButton(
              onPressed: () {
                Beamer.of(context).beamToNamed(
                    '/home/project/k5KTXwyilMpQDH28w3An/record/add');
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}

// Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               child: const Text("Add Project"),
//               onPressed: () {
//                 Beamer.of(context).beamToNamed('/home/add/project');
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Project Details"),
//               onPressed: () {
//                 Beamer.of(context)
//                     .beamToNamed('/home/project/k5KTXwyilMpQDH28w3An');
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Add Record"),
//               onPressed: () {
//                 Beamer.of(context).beamToNamed(
//                     '/home/project/k5KTXwyilMpQDH28w3An/record/add');
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Logout"),
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 Beamer.of(context).beamToNamed('/login');
//               },
//             ),
//           ],
//         ),
//       )