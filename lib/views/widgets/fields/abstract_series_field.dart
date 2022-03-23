import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/helpers/snackbar_messages.dart';
import 'package:z_collector_app/views/widgets/fields/abstract_field.dart';

abstract class AbstractSeriesFieldWidget<T> extends AbstractFieldWidget {
  const AbstractSeriesFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: fieldKey,
      validator: buildValidators(context),
      builder: (FormFieldState<SeriesState<T>?> fieldState) {
        final isRecording = fieldState.value?.isRecording ?? false;

        return InputDecorator(
          decoration: InputDecoration(
            label: Text(field.name),
            helperText: field.helperText,
            border: const OutlineInputBorder(),
          ),
          child: Row(
            children: [
              if (isRecording)
                ElevatedButton(
                  child: const Text('Stop'),
                  onPressed: () => _stopRecording(context, fieldState),
                ),
              if (!isRecording)
                ElevatedButton(
                  child: const Text('Start'),
                  onPressed: () => _startRecording(context, fieldState),
                ),
              if (isRecording)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Recording...'),
                ),
              if (!isRecording && fieldState.value != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Records: ${fieldState.value?.data.length}'),
                ),
            ],
          ),
        );
      },
    );
  }

  void _startRecording(
    BuildContext context,
    FormFieldState<SeriesState<T>?> fieldState,
  ) async {
    try {
      fieldState.didChange(SeriesState(true, fieldState.value?.data ?? []));
      startCollecting();
    } catch (e) {
      showErrorMessage(context, e.toString());
      fieldState.didChange(null);
    }
  }

  void _stopRecording(
    BuildContext context,
    FormFieldState<SeriesState<T>?> fieldState,
  ) async {
    try {
      final data = endCollecting();
      fieldState.didChange(SeriesState(false, data));
    } catch (e) {
      showErrorMessage(context, e.toString());
      fieldState.didChange(null);
    }
  }

  void startCollecting();

  List<T> endCollecting();
}

class SeriesState<T> {
  final bool isRecording;
  final List<T> data;

  SeriesState(this.isRecording, this.data);
}
