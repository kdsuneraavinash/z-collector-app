import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadJob {
  final String id;
  bool isUploaded;
  final String filePath;
  final String storagePath;

  UploadJob({
    required this.filePath,
    required this.storagePath,
    this.isUploaded = false,
  }) : id = storagePath;

  factory UploadJob.fromJson(Map<String, dynamic> data) {
    return UploadJob(
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

  static Future<List<UploadJob>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasks = prefs.getString('tasks');
    if (tasks == null) {
      return [];
    }
    return (json.decode(tasks) as List)
        .map((item) => UploadJob.fromJson(item))
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
    return other is UploadJob && hashCode == other.hashCode;
  }

  @override
  int get hashCode => id.hashCode;
}

class BackgroundUpload {
  static const TT_SINGLE_TASK = "TT_SINGLE_TASK";
  static const TT_STARTUP_TASKS = "TT_STARTUP_TASKS";
  static const TT_TEST_TASK = "TT_TEST_TASK";
  static const RETRY_COUNT = 3;

  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    _dispatchStatupTasks();
    _dispatchTestTask();
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
            return _handleStartupTasks(inputData);
          case TT_TEST_TASK:
            return _handleTestTask(inputData);
        }
        return Future.value(true);
      },
    );
  }

  static Future<List<UploadJob>> getAllTasks() async {
    return UploadJob.getAll();
  }

  static void dispatchBackgoundUploadTask(UploadJob task) {
    Workmanager().registerOneOffTask(
      "1",
      TT_SINGLE_TASK,
      inputData: task.toJson(),
    );
  }

  static void _dispatchStatupTasks() {
    Workmanager().registerOneOffTask("2", TT_STARTUP_TASKS, inputData: {});
  }

  static void _dispatchTestTask() {
    Workmanager().registerOneOffTask("3", TT_TEST_TASK, inputData: {});
  }

  static Future<bool> _handleStartupTasks(Map<String, dynamic>? data) async {
    final tasks = await getAllTasks();
    for (var task in tasks) {
      if (!task.isUploaded) {
        _uploadTask(task);
      }
    }
    return true;
  }

  static Future<bool> _handleSingleTask(Map<String, dynamic> data) async {
    final task = UploadJob.fromJson(data);
    task.save();
    _uploadTask(task);
    return true;
  }

  static Future<bool> _handleTestTask(Map<String, dynamic>? data) async {
    print("=============Test task==============");
    return true;
  }

  static void _uploadTask(UploadJob task) async {
    for (var i = 0; i < RETRY_COUNT; i++) {
      final uploadDone = await _upload(task);
      if (uploadDone) {
        task.isUploaded = true;
        task.save();
        break;
      }
    }
  }

  static Future<bool> _upload(UploadJob task) async {
    try {
      await FirebaseStorage.instance
          .ref(task.storagePath)
          .putFile(File(task.filePath));
      return true;
    } catch (e) {
      return false;
    }
  }
}
