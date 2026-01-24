import 'package:flutter/material.dart';
import 'package:gauvigyaan/theme/app_theme.dart';

class CustomElevatedBtn extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final bool isActive;
  final Color? color;
  final Color? textColor;
  final bool isBigSize;

  const CustomElevatedBtn({
    this.isActive = true,
    required this.onPressed,
    required this.text,
    this.color,
    this.textColor,
    this.isBigSize = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final textScale = TextUtils.getTextScale(context);
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: isActive ? onPressed : null,
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: color ?? context.colorScheme.secondary,
        fixedSize: isBigSize ? size * .4 : null,
      ),
      child: Text(
        text, textAlign: TextAlign.center,
        // textScaleFactor: 0.9,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor != null ? textColor : context.colorScheme.background,
        ),
      ),
    );
  }
}

class CustomElevatedIconBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;
  final Color? color;
  final Color? iconColor;

  const CustomElevatedIconBtn({
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.iconColor,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      iconAlignment: IconAlignment.end,
      icon: Icon(
        icon,
        color: iconColor,
      ),
      label: Text(
        text,
        style: context.textTheme.labelLarge?.copyWith(color: Colors.white),
      ),
      style: TextButton.styleFrom(
        fixedSize: context.screenSize * .4,
        backgroundColor: color ?? Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class CustomTextBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? color;

  const CustomTextBtn({
    required this.onPressed,
    required this.text,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        foregroundColor: color ?? context.colorScheme.primary,
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class CustomTextIconBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final Color? color;

  const CustomTextIconBtn({
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: TextButton.styleFrom(
        foregroundColor: color ?? Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class CustomOutlinedIconBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;
  final Color? color;

  const CustomOutlinedIconBtn({
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final textScale = TextUtils.getTextScale(context);
    final size = MediaQuery.of(context).size;
    return OutlinedButton.icon(
      onPressed: onPressed,
      label: Icon(icon),
      style: OutlinedButton.styleFrom(
        fixedSize: size * .06,
        foregroundColor: color ?? Theme.of(context).colorScheme.secondary,
        surfaceTintColor: color ?? Theme.of(context).colorScheme.secondary,
        side: BorderSide(
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
      ),
      icon: Text(
        text,
        // textScaleFactor: textScale,
      ),
    );
  }
}

class CustomOutlinedBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isBigSize;

  // final IconData icon;
  final Color? color;

  const CustomOutlinedBtn({
    required this.onPressed,
    required this.text,
    required this.isBigSize,
    // required this.icon,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final textScale = TextUtils.getTextScale(context);
    final size = MediaQuery.of(context).size;
    return OutlinedButton(
      onPressed: onPressed,
      // label: Icon(icon),
      style: TextButton.styleFrom(
        fixedSize: isBigSize ? size * .4 : null,
        padding: AppTheme.boxPadding,
        foregroundColor: color ?? Theme.of(context).colorScheme.secondary,
        surfaceTintColor: color ?? Theme.of(context).colorScheme.secondary,
        side: BorderSide(
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: Text(
        text,
        style: context.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
        // textScaleFactor: textScale,
      ),
    );
  }
}class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    required this.items,
    required this.label,
    required this.onSelect,
    required this.initialSelection, // ✅ Make it required
    this.selectedValue, // ✅ Keep for dynamic updates
    this.fillColor,
  });

  final List<String> items;
  final String label;
  final String initialSelection; // ✅ First time selection
  final String? selectedValue; // ✅ Dynamic selection (for updates)
  final Color? fillColor;
  final void Function(String value) onSelect;

  @override
  Widget build(BuildContext context) {
    // ✅ selectedValue ko priority do, agar null hai to initialSelection use karo
    final String? effectiveValue = selectedValue?.isNotEmpty == true 
        ? selectedValue 
        : (initialSelection.isNotEmpty ? initialSelection : null);

    return DropdownMenu<String>(
      key: ValueKey(effectiveValue), // 🔥 IMPORTANT - rebuilds when value changes
      width: context.screenWidth - 20,
      menuHeight: 300,

      initialSelection: effectiveValue, // ✅ Use effective value

      onSelected: (value) {
        if (value != null) {
          onSelect(value);
        }
      },

      dropdownMenuEntries: items
          .map(
            (e) => DropdownMenuEntry<String>(
              value: e,
              label: e,
            ),
          )
          .toList(),

      label: Text(label),

      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}