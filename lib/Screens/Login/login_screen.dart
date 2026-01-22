import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gauvigyaan/constants/assets.dart';
import 'package:gauvigyaan/providers/loginProvider.dart';
import 'package:gauvigyaan/routing/app_pages.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:gauvigyaan/widgets/button.dart';
import 'package:gauvigyaan/widgets/error_utils.dart';
import 'package:gauvigyaan/widgets/textfield.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/common_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String mobile = '';

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: Container(
        padding: AppTheme.boxPadding,
        height: context.screenHeight,
        width: context.screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.bg),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTheme.verticalSpacing(mul: 5),
              Image.asset(
                Assets.appLogo,
                height: 100,
              ),
              AppTheme.verticalSpacing(),
              Text(
                CommonText.appName,
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              AppTheme.verticalSpacing(mul: 3),

              // Mobile Number Field
              Container(
                height: 80,
                padding: AppTheme.boxPadding,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                child: CustomTextFormField(
                  value: mobile,
                  length: 10,
                  fillColor: true,
                  isBorder: false,
                  hintText: CommonText.mobileNo,
                  inputType: TextInputType.number,
                  onChanged: (val) {
                    mobile = val;
                    setState(() {});
                  },
                  validator: (val) {
                    return "";
                  },
                ),
              ),

              AppTheme.verticalSpacing(mul: 3),

              // Login Button with Gradient
              _buildGradientButton(
                text: CommonText.login,
                onPressed: () async {
                  var res = await provider.login(mobile);
                  if (res['Status'] == 'True') {
                    context.go(AppPages.rule);
                  } else {
                    ErrorUtils.showSimpleInfoDialog(context,
                        message: res['Message']);
                  }
                },
              ),
            // _buildGradientButton(
            //   text: CommonText.login,
            //   onPressed: () {
            //     // context.go(AppPages.home);
            //     context.go(AppPages.rule);
            //   },
            // ),

              AppTheme.verticalSpacing(mul: 2),

              // Register Button with Gradient
              _buildGradientButton(
                text: CommonText.register,
                onPressed: () {
                  context.pushNamed(AppPages.qrScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF850000), Colors.black],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

