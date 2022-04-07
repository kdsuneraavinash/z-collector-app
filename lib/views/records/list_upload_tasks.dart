import 'package:flutter/material.dart';
import 'package:z_collector_app/views/helpers/background_upload.dart';

class UploadTaskList extends StatelessWidget {
  const UploadTaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Record Assets")),
        body: FutureBuilder<List<UploadTask>>(
          future: BackgroundUpload.getAllTasks(),
          builder: (context, snapshot) {
            if (snapshot.hasData && (snapshot.data?.isNotEmpty ?? false)) {
              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(data[index].filePath),
                    trailing: Icon(
                        data[index].isUploaded ? Icons.done : Icons.upload),
                  ),
                ),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Nothing to show."),
            );
          },
        ),
      ),
    );
  }
}
