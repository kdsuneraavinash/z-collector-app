import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/widgets/fields/abstract_field.dart';
import 'package:z_collector_app/views/widgets/fields/audio_field.dart';
import 'package:z_collector_app/views/widgets/fields/boolean_field.dart';
import 'package:z_collector_app/views/widgets/fields/checkboxes_field.dart';
import 'package:z_collector_app/views/widgets/fields/date_field.dart';
import 'package:z_collector_app/views/widgets/fields/datetime_field.dart';
import 'package:z_collector_app/views/widgets/fields/dropdown_field.dart';
import 'package:z_collector_app/views/widgets/fields/image_field.dart';
import 'package:z_collector_app/views/widgets/fields/location_field.dart';
import 'package:z_collector_app/views/widgets/fields/location_series_field.dart';
import 'package:z_collector_app/views/widgets/fields/numeric_field.dart';
import 'package:z_collector_app/views/widgets/fields/radio_field.dart';
import 'package:z_collector_app/views/widgets/fields/string_field.dart';
import 'package:z_collector_app/views/widgets/fields/text_field.dart';
import 'package:z_collector_app/views/widgets/fields/time_field.dart';
import 'package:z_collector_app/views/widgets/fields/video_field.dart';

class RecordFieldWidget extends AbstractFieldWidget {
  const RecordFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  Widget build(BuildContext context) {
    switch (field.type) {
      case ProjectFieldType.string:
        return StringFieldWidget(index: index, field: field);
      case ProjectFieldType.numeric:
        return NumericFieldWidget(index: index, field: field);
      case ProjectFieldType.location:
        return LocationFieldWidget(index: index, field: field);
      case ProjectFieldType.locationSeries:
        return LocationSeriesFieldWidget(index: index, field: field);
      case ProjectFieldType.image:
        return ImageFieldWidget(index: index, field: field);
      case ProjectFieldType.video:
        return VideoFieldWidget(index: index, field: field);
      case ProjectFieldType.audio:
        return AudioFieldWidget(index: index, field: field);
      case ProjectFieldType.text:
        return TextFieldWidget(index: index, field: field);
      case ProjectFieldType.boolean:
        return BooleanFieldWidget(index: index, field: field);
      case ProjectFieldType.dateTime:
        return DateTimeFieldWidget(index: index, field: field);
      case ProjectFieldType.date:
        return DateFieldWidget(index: index, field: field);
      case ProjectFieldType.time:
        return TimeFieldWidget(index: index, field: field);
      case ProjectFieldType.dropdown:
        return DropDownFieldWidget(index: index, field: field);
      case ProjectFieldType.radio:
        return RadioFieldWidget(index: index, field: field);
      case ProjectFieldType.checkBoxes:
        return CheckBoxesFieldWidget(index: index, field: field);
      default:
        return StringFieldWidget(index: index, field: field);
    }
  }
}
