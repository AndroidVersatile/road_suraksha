import 'package:flutter/material.dart';
import 'package:gauvigyaan/providers/home_provider.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:gauvigyaan/widgets/button.dart';
import 'package:gauvigyaan/widgets/error_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String comment = "";

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('अपना सुझाव भेजे'),
      ),
      body: Container(
        margin: AppTheme.boxPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'क्या आपके पास कोई सुझाव है या कुछ त्रुटि पाई गई है?\nहमें नीचे दिए गए क्षेत्र में बताएं ।',
                textAlign: TextAlign.start,
              ),
              AppTheme.verticalSpacing(),
              Container(
                color: Colors.grey.shade300,
                height: 200,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  onChanged: (val) {
                    comment = val;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'यहां अपने अनुभव का वर्णन करें',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: AppTheme.boxPadding,
                  ),
                ),
              ),
              AppTheme.verticalSpacing(mul: 3),
              CustomElevatedBtn(
                  onPressed: () async {
                    var res = await provider.sendFeedback(
                      msg: comment,
                    );

                    if (res == 200) {
                      ErrorUtils.showSimpleInfoDialog(context, onConfirm: () {
                        context.pop();
                      },
                          icon: Icons.check_circle,
                          btnText: 'Ok',
                          color: Colors.green,
                          content: const Text(
                            'आपकी प्रतिक्रिया सफलतापूर्वक प्रस्तुत कर दी गई है।',
                            textAlign: TextAlign.center,
                          ));
                    }
                  },
                  text: 'भेजें')
            ],
          ),
        ),
      ),
    );
  }
}
