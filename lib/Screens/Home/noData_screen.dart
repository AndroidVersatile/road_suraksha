import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../constants/assets.dart';
import '../../routing/app_pages.dart';
import '../../theme/app_theme.dart';
import '../../widgets/button.dart';

class NoDataScreen extends StatelessWidget {
  NoDataScreen(
      {required this.subtitle,
      required this.buttonText,
      required this.image,
      required this.onPressed,
      required this.title,
      this.isOtherWidget = false,
      this.widget = const SizedBox.shrink(),
      super.key});

  String image;
  String title;
  String subtitle;
  String buttonText;
  bool isOtherWidget;
  Widget widget;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.screenHeight,
        padding: AppTheme.boxPadding,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(image, height: 250),
              // AppTheme.verticalSpacing(mul: 3),
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium,
              ),
              AppTheme.verticalSpacing(mul: 1),
             if (subtitle.isNotEmpty)    Text(
                subtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.labelMedium,
              ),
              AppTheme.verticalSpacing(mul: 2),
              CustomElevatedBtn(
                onPressed:onPressed,
                text: buttonText,
                isBigSize: true,
              ),
              if (isOtherWidget) widget,
            ],
          ),
        ),
      ),
    );
  }
}
