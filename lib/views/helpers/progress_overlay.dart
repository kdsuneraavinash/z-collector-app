import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:z_collector_app/providers/progress_provider.dart';

class ProgressOverlay extends ConsumerWidget {
  final Widget child;

  const ProgressOverlay({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Stack(
      children: [
        child,
        if (progress)
          Container(
            color: Theme.of(context).scaffoldBackgroundColor.withAlpha(127),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
