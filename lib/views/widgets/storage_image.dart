import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageImage extends StatelessWidget {
  final String? storageUrl;

  const StorageImage({Key? key, required this.storageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: storageUrl == null
          ? Future.value()
          : FirebaseStorage.instance.ref(storageUrl).getDownloadURL(),
      builder: (context, urlSnapshot) => Image.network(
        urlSnapshot.data ?? "https://via.placeholder.com/200x200",
        fit: BoxFit.cover,
        color: Colors.black.withAlpha(127),
        colorBlendMode: BlendMode.srcOver,
      ),
    );
  }
}
