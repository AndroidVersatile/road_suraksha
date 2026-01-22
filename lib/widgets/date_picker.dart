import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'date_utils.dart';

class PickTimeWidget extends StatefulWidget {
  final String title;
  final bool isPreviousDate;
  final bool isFutureDate;
  final bool enabled;
  final void Function(DateTime date) onPickedDate;
  final DateTime initialValue;

  const PickTimeWidget(
      {required this.title,
      this.isPreviousDate = false,
      this.isFutureDate = true,
      this.enabled = true,
      required this.onPickedDate,
      required this.initialValue,
      Key? key})
      : super(key: key);

  @override
  State<PickTimeWidget> createState() => _PickTimeWidgetState();
}

class _PickTimeWidgetState extends State<PickTimeWidget> {
  late DateTime currentTime;

  @override
  void initState() {
    currentTime = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      tileColor: Colors.white,
      shape: !widget.enabled ? null : AppTheme.shape.copyWith(),
      trailing: !widget.enabled
          ? null
          : Icon(
              Icons.access_time,
              color: Color(0xFF8189B0),
            ),
      title: Text(
        widget.title,
        style: context.textTheme.labelMedium?.copyWith(
          color: Color(0xFF8189B0),
        ),
      ),
      leading: Icon(
        Icons.calendar_month_outlined,
        color: Color(0xFF8189B0),
      ),
      onTap: !widget.enabled ? null : chooseDate,
      subtitle: Text(DatesUtils.getFormattedDateOnly(currentTime), style: context.textTheme.labelLarge?.copyWith(
        // color: Color(0xFF8189B0),
      ),),
    );
  }

  void chooseDate() async {
    var resultDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.isPreviousDate ? DateTime(1922) : DateTime.now(),
      lastDate: widget.isFutureDate ? DateTime(3000) : DateTime.now(),
    );

    // if (resultDate != null && mounted) {
    //   var resultTime = await showTimePicker(
    //     context: context,
    //     initialTime: TimeOfDay.now(),
    //   );

    if (resultDate != null) {
      currentTime = DateTime(
        resultDate.year,
        resultDate.month,
        resultDate.day,
      );

      setState(() {
        widget.onPickedDate(currentTime);
      });
    }
  }
// }
}
