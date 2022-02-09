import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/widgets/fields/abstract_field.dart';

class BooleanFieldWidget extends AbstractFieldWidget {
  const BooleanFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    return FormBuilderSwitch(
      name: fieldKey,
      title: Text(field.name),
      decoration: InputDecoration(
        helperText: field.helperText,
        border: const OutlineInputBorder(),
      ),
      validator: buildValidators(context),
    );
  }
}
