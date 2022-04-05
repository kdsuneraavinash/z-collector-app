import 'package:workmanager/workmanager.dart';

class BackgroundUpload {
  static void initialize() {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
  }

  static void callbackDispatcher() {
    Workmanager().executeTask(
      (task, inputData) {
        print(
            "Native called background task: $task"); //simpleTask will be emitted here.
        _upload();
        return Future.value(true);
      },
    );
  }

  static void dispatchBackgoundUploadTask() {
    // TODO: implement dispatchBackgoundUpload

    // Upload file path
    // firesebae storage path
  }

  static void _upload() {
    // TODO: Add upload logic
    // Write task in shared preferences (seriealized) with unique id
    // Start upload (retry if failed)
    // Remove shared preferences entry after done

    // Changes to database
    // New files collection to store all files and the status of the upload
  }
}
