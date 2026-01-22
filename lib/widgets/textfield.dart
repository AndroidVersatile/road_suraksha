import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      this.onChanged,
      this.fillColor = true,
      this.filledColor = Colors.white,
      this.inputType = TextInputType.text,
      this.length,
      this.validator,
      this.hintText = "",
      this.value,
      this.iconData,
      this.autoFocus = false,
      this.enabled = true,
      this.suffix,
      this.autofillHints = const [],
      this.inputFormatter = const [],
      this.successIconData,
      this.autoValidateMode,
      this.controller,
      this.isBorder = false,
      this.obscureText = false,
      this.onFieldSubmitted})
      : super(key: key);

  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final bool enabled;
  final bool obscureText;
  final bool fillColor;
  final Color? filledColor;
  final TextInputType inputType;
  final int? length;
  final String? Function(String?)? validator;
  final String hintText;
  final IconData? iconData;
  final IconData? successIconData;
  final String? value;
  final List<String>? autofillHints;
  final Widget? suffix;
  final bool autoFocus;
  final bool isBorder;
  final List<TextInputFormatter> inputFormatter;
  final AutovalidateMode? autoValidateMode;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      autofillHints: autofillHints,
      onChanged: onChanged,
      autofocus: autoFocus,
      enabled: enabled,
      obscureText: obscureText,
      maxLength: length,
      keyboardType: inputType,
      autovalidateMode: autoValidateMode,
      validator: validator,
      initialValue: value,
      inputFormatters: inputFormatter,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: onFieldSubmitted,
      decoration: enabled
          ? InputDecoration(
              prefixIcon: iconData != null
                  ? Icon(
                      iconData,
                      size: 24,
                      color: Color(0xFF8189B0),
                    )
                  : null,
              suffixIcon: successIconData != null
                  ? Icon(
                      successIconData,
                      color: Colors.green,
                      size: 24,
                    )
                  : null,
              suffix: suffix,
              suffixIconColor: Color(0xFF8189B0),
              isDense: true,
              labelText: hintText,
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              filled: fillColor,
              fillColor: filledColor,
              //Colors.white,
              counter: const SizedBox(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: isBorder
                    ? const BorderSide(
                        color: Colors.black,
                      )
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: isBorder
                    ? BorderSide(color: theme.colorScheme.primary)
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
            )
          : InputDecoration(
              labelText: hintText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  borderSide: BorderSide.none),
              filled: fillColor,
              fillColor: Colors.white,
              isDense: true,
              counter: const SizedBox(),
              prefixIcon: iconData != null
                  ? Icon(
                      iconData,
                      size: 24,
                      color: Color(0xFF8189B0),
                    )
                  : null,
              suffixIcon: successIconData != null
                  ? Icon(
                      successIconData,
                      color: Colors.green,
                      size: 24,
                    )
                  : null,
              suffix: suffix,
              suffixIconColor: Color(0xFF8189B0),
            ),
    );
  }
}
