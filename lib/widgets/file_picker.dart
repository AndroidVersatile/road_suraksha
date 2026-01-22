import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'button.dart';

class ChoosePaperWidget extends StatefulWidget {
  final String title;
  final bool isButton;
  final bool isScanner;
  final String? filePath;
  final String type;
  final String docType;
  final void Function(Uint8List fileData) onFileSelected;

  const ChoosePaperWidget({
    required this.title,
    required this.onFileSelected,
    this.isButton = false,
    this.isScanner = false,
    this.filePath,
    required this.type,
    required this.docType,
    Key? key,
  }) : super(key: key);

  @override
  State<ChoosePaperWidget> createState() => _ChoosePaperWidgetState();
}

class _ChoosePaperWidgetState extends State<ChoosePaperWidget> {
  String filePath = "";
  bool isLoading = false;

  @override
  void initState() {
    if (widget.filePath != null) filePath = widget.filePath!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.isButton) {
    //   return CustomOutlinedBtn(
    //     onPressed: showChooseDialog,
    //     text: widget.title,
    //   );
    // }

    return Card(
      color: Colors.grey.shade200,
      child: ListTile(
        iconColor: Colors.black,
        trailing: isLoading
            ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(),
              )
            : null,
        onTap: showChooseDialog,
        title: Text(filePath.isNotEmpty ? "" : widget.title,
            style: context.textTheme.labelLarge),
        subtitle: filePath.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (filePath.isNotEmpty)
                  Text(
                    filePath.split("/").last,
                    style: context.textTheme.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // if (filePath.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // CustomTextBtn(onPressed: showFile, text: "View"),
                      CustomTextBtn(
                        onPressed: showChooseDialog,
                        text: "Change",
                      ),

                      CustomTextBtn(
                        onPressed: () async{
                          ///UPLOAD IMAGE API -->>> KYC
                          // final image = await base64.encode(utf8.encode(result.toString()));
                          final image = await base64.encode(result);
                        },
                        text: "Upload",
                      ),
                    ],
                  )
                ],
              )
            : null,
        leading: filePath.isEmpty
            ? const Icon(Icons.upload)
            : const Icon(
                Icons.add_task,
                color: Colors.green,
              ),
      ),
    );
  }

  // void showFile() {
  //   //Printing.sharePdf(bytes: File(filePath).readAsBytesSync());
  //   showGeneralDialog(
  //     context: context,
  //     pageBuilder: (context, anim1, anim2) => PdfPreviewWidget(
  //       isExam: false,
  //       title: "Selected Pdf",
  //       url: filePath,
  //
  //       isFromFile: true,
  //     ),
  //   );
  // }
  var result;
  void showChooseDialog() async {
     result = await pickFile();
    if (result != null) widget.onFileSelected(result);
  }

  Future<Uint8List?> pickFile() async {
    Uint8List? fileData;
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        fileData = result.files.first.bytes;
      }
      return fileData;
    }
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withData: true,
      withReadStream: true,
      allowCompression: true,
      allowedExtensions: ['png', 'jpeg', 'jpg'],
    );

    if (result != null) {
      setState(() {
        isLoading = true;
      });
      filePath = result.files.first.path ?? "";
      fileData = result.files.first.bytes;
      setState(() {
        isLoading = false;
      });
    }

    return fileData;
  }

// Future<String> pickImage() async {
//   var result = await FilePicker.platform.pickFiles(
//     type: FileType.image,
//     allowMultiple: true,
//   );
//   if (result != null) {
//     setState(() {
//       isLoading = true;
//     });
//     List<Uint8List> list = List.empty(growable: true);
//     for (var element in result.files) {
//       var file = File(element.path!);
//       list.add(file.readAsBytesSync());
//     }
//     var pdf = await convertImageToPDF(list.reversed.toList());
//
//     setState(() {
//       filePath = pdf;
//       isLoading = false;
//     });
//     return pdf;
//   }
//   return "";
// }
}
