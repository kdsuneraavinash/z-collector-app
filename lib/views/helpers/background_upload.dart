import 'dart:convert';

import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadTask {
  final String id;
  bool isUploaded;
  String filePath;
  String storagePath;

  UploadTask({
    required this.isUploaded,
    required this.filePath,
    required this.storagePath,
  }) : id = storagePath;

  factory UploadTask.fromJson(Map<String, dynamic> data) {
    return UploadTask(
      isUploaded: data['isUploaded'] as bool,
      filePath: data['filePath'] as String,
      storagePath: data['storagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'isUploaded': isUploaded,
      'filePath': filePath,
      'storagePath': storagePath,
    };
  }

  String toSerialized() {
    return json.encode(toJson());
  }

  static Future<List<UploadTask>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasks = prefs.getString('tasks');
    if (tasks == null) {
      return [];
    }
    return (json.decode(tasks) as List)
        .map((item) => UploadTask.fromJson(item))
        .toList();
  }

  Future<bool> save() async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getAll();
    final i = tasks.indexOf(this);
    if (i == -1) {
      tasks.add(this);
    } else {
      tasks[i] = this;
    }
    return await prefs.setString('tasks', json.encode(tasks));
  }

  @override
  bool operator ==(Object other) {
    return other is UploadTask && hashCode == other.hashCode;
  }

  @override
  int get hashCode => id.hashCode;
}

class BackgroundUpload {
  static const TT_SINGLE_TASK = "TT_SINGLE_TASK";
  static const TT_STARTUP_TASKS = "TT_STARTUP_TASKS";
  static const RETRY_COUNT = 3;

  static void initialize() {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    dispatchStatupTasks();
  }

  static void callbackDispatcher() {
    Workmanager().executeTask(
      (task, inputData) {
        print(
            "Native called background task: $task"); //simpleTask will be emitted here.
        switch (task) {
          case TT_SINGLE_TASK:
            return _handleSingleTask(inputData!);
          case TT_STARTUP_TASKS:
            return _handleStartupTasks();
        }
        return Future.value(true);
      },
    );
  }

  static Future<List<UploadTask>> getAllTasks() async {
    return UploadTask.getAll();
  }

  static void dispatchBackgoundUploadTask(UploadTask task) {
    Workmanager().registerOneOffTask(
      "1",
      TT_SINGLE_TASK,
      inputData: task.toJson(),
    );
  }

  static void dispatchStatupTasks() {
    Workmanager().registerOneOffTask("2", TT_STARTUP_TASKS);
  }

  static Future<bool> _handleStartupTasks() async {
    final tasks = await getAllTasks();
    for (var task in tasks) {
      if (!task.isUploaded) {
        _uploadTask(task);
      }
    }
    return true;
  }

  static Future<bool> _handleSingleTask(Map<String, dynamic> data) async {
    final task = UploadTask.fromJson(data);
    task.save();
    _uploadTask(task);
    return true;
  }

  static void _uploadTask(UploadTask task) async {
    for (var i = 0; i < RETRY_COUNT; i++) {
      final uploadDone = await _upload(task);
      if (uploadDone) {
        task.isUploaded = true;
        task.save();
        break;
      }
    }
  }

  static Future<bool> _upload(UploadTask task) {
    // TODO: Add upload logic
    // Write task in shared preferences (seriealized) with unique id
    // Start upload (retry if failed)
    // Remove shared preferences entry after done

    // Changes to database
    // New files collection to store all files and the status of the upload
    return Future.value(true);
  }
}
