import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/models/record.dart';
import 'package:z_collector_app/views/helpers/formdata_manager.dart';
import 'package:z_collector_app/providers/progress_provider.dart';
import 'package:z_collector_app/views/helpers/firebase_builders.dart';
import 'package:z_collector_app/views/helpers/snackbar_messages.dart';
import 'package:z_collector_app/views/widgets/fields/record_field.dart';

class AddRecordPage extends StatelessWidget {
  final String projectId;

  const AddRecordPage({Key? key, required this.projectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectRef =
        FirebaseFirestore.instance.collection('projects').doc(projectId);

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Record")),
      body: FirestoreFutureBuilder(
        future: projectRef.get(),
        builder: (context, projectData) => AddRecordPageForm(
          projectId: projectId,
          project: Project.fromJson(projectData),
        ),
      ),
    );
  }
}

class AddRecordPageForm extends ConsumerWidget {
  final String projectId;
  final Project project;
  final _formKey = GlobalKey<FormBuilderState>();

  AddRecordPageForm({Key? key, required this.projectId, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: project.fields.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: RecordFieldWidget(
                  key: Key(index.toString()),
                  index: index,
                  field: project.fields[index],
                ),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _handleCencel(context),
                  child: const Text("Cancel"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).errorColor),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _handleSubmit(context, ref),
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleCencel(BuildContext context) {
    Beamer.of(context).beamBack();
  }

  void _handleSubmit(BuildContext context, WidgetRef ref) async {
    final formState = _formKey.currentState!;
    if (!formState.validate()) return;
    formState.save();

    final formData = formState.value;

    final progressNotifier = ref.read(progressProvider.notifier);
    progressNotifier.start();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showErrorMessage(context, 'You are logged out!');
        Beamer.of(context).beamToNamed('/login');
        return;
      }

      final formDataManager = FormDataManager(
          projectId: projectId, userId: user.uid, project: project);
      final fieldValues = formDataManager.extract(formData);
      final record = Record(
        user: FirebaseFirestore.instance.collection('users').doc(user.uid),
        project:
            FirebaseFirestore.instance.collection('projects').doc(projectId),
        timestamp: Timestamp.now(),
        status: RecordStatus.done,
        fields: fieldValues,
      );
      FirebaseFirestore.instance.collection('records').add(record.toJson());
      formDataManager.startUploading();
      showSuccessMessage(context, 'Record is being uploaded...');
      Beamer.of(context).beamBack();
    } catch (e) {
      showErrorMessage(context, 'Something went wrong!! Please try again.');
    } finally {
      progressNotifier.stop();
    }
  }
}
