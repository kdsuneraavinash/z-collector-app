import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/widgets/fields/abstract_series_field.dart';

class LocationSeriesFieldWidget extends AbstractSeriesFieldWidget<Position> {
  const LocationSeriesFieldWidget(
      {Key? key, required int index, required ProjectField field})
      : super(key: key, index: index, field: field);

  @override
  void startCollecting() {
    // TODO: implement startCollecting
  }

  @override
  List<Position> endCollecting() {
    // TODO: implement endCollecting
    return [];
  }
}
