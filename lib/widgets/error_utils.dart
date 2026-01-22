import 'dart:convert';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gauvigyaan/widgets/video_player.dart';
import 'package:go_router/go_router.dart';


import '../routing/app_routing.dart';
import '../theme/app_theme.dart';
import 'button.dart';

class ErrorUtils {
  ErrorUtils._();

  static Color onError = const Color(0xFFBA1B1B);
  static Color textColor = const Color(0xFFFFFFFF);
  static Color primary = const Color(0xFF203A6E);
  static final textStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textColor,
  );

  static showErrorSnackBar(String message) async {
    final mes = rootScaffoldMessengerKey.currentState;
    try {
      mes!.clearSnackBars();
      mes.hideCurrentSnackBar();
      FocusManager.instance.primaryFocus!.unfocus();
      mes.showSnackBar(
        SnackBar(
          elevation: 0,
          content: Chip(
            label: Text(
              message,
              style: textStyle,
              maxLines: 3,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            backgroundColor: onError,
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 90),
          duration: const Duration(milliseconds: 2000),
        ),
      );
    } catch (e) {
      // mes.clearMaterialBanners();
    }
  }

  static showSuccessSnackBar(String message) async {
    // var mes = ScaffoldMessenger.of(context);
    final mes = rootScaffoldMessengerKey.currentState;

    try {
      mes!.clearSnackBars();
      FocusManager.instance.primaryFocus!.unfocus();
      mes.showSnackBar(
        SnackBar(
          elevation: 0,
          content: Chip(
            label: Text(
              message,
              style: textStyle,
            ),
            backgroundColor: primary,
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 90),
          duration: const Duration(milliseconds: 1000),
        ),
      );
    } catch (e) {
      // mes.clearMaterialBanners();
    }
  }

  static showDeleteDialog(BuildContext context,
      {required dynamic onDeleted}) async {
    // final message = LanguageHelper.of(context)!.deleteMessage;
    await showConfirmDialog(context,
        onConfirm: onDeleted,
        message: 'Delete',
        icon: Icons.delete,
        color: Colors.red);
  }

  static showConfirmDialog(
    BuildContext context, {
    String? message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    IconData icon = Icons.add_task,
    double size = 48,
    String confirmText = "yes",
    String anotherText = "No",
    Color color = Colors.green,
    Widget? content,
    bool hideOtherOption = false,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) => AlertDialog(
        title: Icon(
          icon,
          size: size,
          color: color,
        ),
        content: content ??
            Text(
              message ?? 'Are you sure?' ,
              textAlign: TextAlign.center,
            ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          /// if we hiding other option
          if (hideOtherOption == false)
            CustomTextBtn(
              onPressed: () {
                Navigator.pop(ctx);
                if (onCancel != null) onCancel();
              },
              text: anotherText,
              color: color,
            ),
          CustomElevatedBtn(isBigSize: false,
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            text: confirmText,
            color: color,
          )
        ],
      ),
    );
  }

  static showSimpleInfoDialog(BuildContext context,
      {String message = "",
      String btnText = "OK",
      Widget? content,
      VoidCallback? onConfirm,
      Color color = Colors.red,
      IconData icon = FontAwesomeIcons.exclamation,
      double size = 24.0}) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => Dialog(
        child: Container(
          width: context.screenWidth * 0.7,
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTheme.verticalSpacing(mul: 2),
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(
                    icon,
                    color: color,
                    size: size,
                  ),
                ),
                AppTheme.verticalSpacing(),
                content ??
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                AppTheme.verticalSpacing(mul: 2),
                const Divider(),
                TextButton(
                  onPressed: () => {
                    context.pop(),
                    if (onConfirm != null) {onConfirm()}
                  },
                  child: Text(btnText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static log(message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static void showLoadingDialog(BuildContext context) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            color: Colors.transparent,
            height: 300,
            width: double.infinity,
            child: Center(
              // child: AppLoadingIndicator(),
            ),
          ),
        );
      },
    );
    await Future.delayed(
      Duration(milliseconds: 300),
      () {
        ErrorUtils.hideDialog(context);
      },
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static String convertJsonToBase64(Map<String, dynamic> model) {
    final jsonString = base64.encode(utf8.encode(json.encode(model)));
    return jsonString;
  }

  static Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }

  static Map<String, dynamic> convertBase64ToJson(String str) {
    final temp = const Base64Decoder().convert(str);
    final String idString = const Utf8Decoder().convert(temp);
    final data = jsonDecode(idString);
    return data;
  }

  static String convertBase64ToString(String str) {
    final temp = const Base64Decoder().convert(str);
    final String idString = const Utf8Decoder().convert(temp);
    return idString;
  }
}
