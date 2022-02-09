import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/providers/progress_provider.dart';
import 'package:z_collector_app/views/helpers/progress_overlay.dart';
import 'package:z_collector_app/views/widgets/fields/record_field.dart';

class AddRecordPage extends StatelessWidget {
  const AddRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Z- Collector Register")),
      body: ProgressOverlay(child: AddRecordPageForm()),
    );
  }
}

class AddRecordPageForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  AddRecordPageForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fields = [
      ProjectField(
        name: "Demo Field",
        type: ProjectFieldType.string,
        helperText: 'This is simple helper text',
        validators: [
          ProjectFieldValidator(
            type: ProjectFieldValidatorType.required,
            value: null,
          ),
        ],
        options: null,
      ),
      ProjectField(
        name: "Demo Field 2",
        type: ProjectFieldType.boolean,
        helperText: 'This is simple helper text',
        validators: [
          ProjectFieldValidator(
            type: ProjectFieldValidatorType.required,
            value: null,
          ),
        ],
        options: null,
      ),
      ProjectField(
        name: "Demo Field 3",
        type: ProjectFieldType.text,
        helperText: 'This is simple helper text',
        validators: [
          ProjectFieldValidator(
            type: ProjectFieldValidatorType.required,
            value: null,
          ),
        ],
        options: null,
      ),
    ];

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: RecordFieldWidget(
                  key: Key(index.toString()),
                  index: index,
                  field: fields[index],
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
    Navigator.pop(context);
  }

  void _handleSubmit(BuildContext context, WidgetRef ref) async {
    final formState = _formKey.currentState!;
    if (!formState.validate()) return;
    formState.save();

    final formData = formState.value;

    final progressNotifier = ref.read(progressProvider.notifier);
    progressNotifier.start();
    try {
      print(formData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('Form cannot be submitted!'),
            backgroundColor: Theme.of(context).errorColor),
      );
    } finally {
      progressNotifier.stop();
    }
  }
}
