import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/helpers/snackbar_messages.dart';
import 'package:z_collector_app/views/widgets/fields/base_field_utils.dart';

abstract class AbstractSeriesFieldWidget<T> extends StatefulWidget {
  final int index;
  final ProjectField field;

  const AbstractSeriesFieldWidget(
      {Key? key, required this.index, required this.field})
      : super(key: key);

  @override
  State<AbstractSeriesFieldWidget<T>> createState() =>
      _AbstractSeriesFieldWidgetState<T>();

  Future<T?> collect();
}

class _AbstractSeriesFieldWidgetState<T>
    extends State<AbstractSeriesFieldWidget<T>> {
  List<T> data;
  Timer? timer;

  _AbstractSeriesFieldWidgetState() : data = [];

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get fieldKey => widget.index.toString();

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: fieldKey,
      validator: BaseFieldUtils.buildValidators(context, widget.field),
      builder: (FormFieldState<List<T>?> fieldState) {
        final isRecording = timer != null;

        return InputDecorator(
          decoration: InputDecoration(
            label: Text(widget.field.name),
            helperText: widget.field.helperText,
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
                  child: Text('Records: ${fieldState.value?.length}'),
                ),
            ],
          ),
        );
      },
    );
  }

  void _startRecording(
    BuildContext context,
    FormFieldState<List<T>?> fieldState,
  ) async {
    try {
      setState(() {
        data = fieldState.value ?? [];
        timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (mounted) {
            final value = await widget.collect();
            if (mounted && value != null) {
              data.add(value);
            }
          }
        });
      });
    } catch (e) {
      showErrorMessage(context, e.toString());
      fieldState.didChange(null);
    }
  }

  void _stopRecording(
    BuildContext context,
    FormFieldState<List<T>?> fieldState,
  ) async {
    try {
      setState(() {
        fieldState.didChange(data);
        timer?.cancel();
        timer = null;
      });
    } catch (e) {
      showErrorMessage(context, e.toString());
      fieldState.didChange(null);
    }
  }
}
