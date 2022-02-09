import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/views/helpers/progress_overlay.dart';

typedef OnDataWidgetBuilder = Widget Function(
    BuildContext context, Map<String, dynamic> data);

class FirestoreFutureBuilder extends StatelessWidget {
  final OnDataWidgetBuilder builder;
  final Future<DocumentSnapshot<Map<String, dynamic>>>? future;

  const FirestoreFutureBuilder(
      {Key? key, required this.future, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorView(errorMessage: snapshot.error.toString());
        }
        final data = snapshot.data?.data();
        if (data == null) return const ProgressOverlay(loading: true);
        return ProgressOverlay(child: builder(context, data));
      },
    );
  }
}

class FirestoreStreamBuilder extends StatelessWidget {
  final OnDataWidgetBuilder builder;
  final Stream<DocumentSnapshot<Map<String, dynamic>>>? stream;

  const FirestoreStreamBuilder(
      {Key? key, required this.stream, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorView(errorMessage: snapshot.error.toString());
        }
        final data = snapshot.data?.data();
        if (data == null) return const ProgressOverlay(loading: true);
        return ProgressOverlay(child: builder(context, data));
      },
    );
  }
}

class ErrorView extends StatelessWidget {
  final String errorMessage;

  const ErrorView({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).errorColor,
        ),
      ),
    ));
  }
}
