import 'package:flutter/material.dart';



CustomAppbarWidget({
  required context,
  final title,
  List<Widget>? action,
  final VoidCallback? onPressed,
  bool isBack = true,
}) {
  return AppBar(
    // flexibleSpace: FlexibleSpaceBar(
      // background: Image.asset(
      //   Assets.shop,
      //   fit: BoxFit.cover,
      //   height: 70,
      // ),
    // ),
    automaticallyImplyLeading: isBack,
    // toolbarHeight: 50,
    actions: action??[],
    leading: isBack
        ? IconButton(
            icon: Icon(Icons.adaptive.arrow_back_rounded),
            color: Theme.of(context).colorScheme.primary,
            onPressed: onPressed ??
                () {
                  context.pop();
                })
        : null,
    title: Text(title,),
  );
}
