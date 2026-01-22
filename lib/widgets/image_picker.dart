import 'dart:convert';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../providers/loginProvider.dart';


// File? image;

Future pickImage(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () async {
              await setImage(ImageSource.camera, context).then((value) async{
                print(value);

                final image = await base64.encode(value);
                print(image);
                context.read<LoginProvider>().userImagePath = image;
              // await  context.read<LoginProvider>().uploadProfilePic();
                context.read<LoginProvider>().update();
                Navigator.pop(ctx);
              });
            },
            title: const Text('Camera'),
            leading: const Icon(
              Icons.camera,
            ),
          ),
          ListTile(
            onTap: () async {
              await setImage(ImageSource.gallery, context).then((value) async{
                print(value);

                final image = await base64.encode(value);
                print(image);
                context.read<LoginProvider>().userImagePath = image;
                // await  context.read<LoginProvider>().uploadProfilePic();
                context.read<LoginProvider>().update();
                Navigator.pop(ctx);
              });
            },
            title: const Text('Gallery'),
            leading: const Icon(Icons.browse_gallery),
          ),
        ],
      );
    },
  );
}

Future setImage(ImageSource source, BuildContext context) async {
  final image = await ImagePicker().pickImage(source: source);
  final imagePath = await image?.readAsBytes() ;

  return imagePath;
}

Future<String> createFolderInAppDocDir({String folderName = 'DayJoy'}) async {
  final Directory? appDocDir = await getApplicationDocumentsDirectory();
  final Directory appDocDirFolder = Directory('${appDocDir?.path}/$folderName');
  if (await appDocDirFolder.exists()) {
    return appDocDirFolder.path;
  } else {
    final Directory appDocDirNewFolder =
        await appDocDirFolder.create(recursive: true);
    return appDocDirNewFolder.path;
  }
}

Future<dynamic> downloadFile(
  String filename,
  Uint8List memoryImageData,
) async {
  // Client client = new Client();
  // var req = await client.get(Uri.parse(url));

  ///String dir = (await getApplicationDocumentsDirectory()).path;
  final String dir = await createFolderInAppDocDir();
  final File file = File('$dir/$filename');

  // await Dio().download(url, file.path, onReceiveProgress: (count, total) {
  //   if (progress == null) {
  //     return;
  //   }
  //   progress((count / total).toDouble());
  // });
  await file.writeAsBytes(memoryImageData);
  final bytes = file.readAsBytesSync();

  ///on web file not supported so returning bytes
  if (kIsWeb) {
    return bytes;
  }
  return file;
}
