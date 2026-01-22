import 'package:flutter/material.dart';
import 'package:gauvigyaan/routing/app_pages.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:gauvigyaan/widgets/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/home_provider.dart';

class LiveInstructionListScreen extends StatefulWidget {
  const LiveInstructionListScreen({required this.type, super.key});

  final String type;

  @override
  State<LiveInstructionListScreen> createState() =>
      _LiveInstructionListScreenState();
}

class _LiveInstructionListScreenState extends State<LiveInstructionListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) async {
        await context.read<HomeProvider>().getExamInstruction();

      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('परीक्षा की महत्वपूर्ण जानकारी'),
      ),
      body: Container(
        height: context.screenHeight,
        margin: AppTheme.boxPadding,
        child: provider.loading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              // flex: 9,
              child: ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                itemCount: provider.instructionList.length,
                itemBuilder: (context, index) {
                  var news = provider.instructionList[index];
                  return Container(
                    padding: AppTheme.boxPadding,
                    margin: AppTheme.boxPadding,
                    decoration:
                    BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.2,
                        blurRadius: 2,
                        color:
                        context.colorScheme.shadow.withOpacity(0.6),
                      ),
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(child: Text('${index + 1}')),
                        AppTheme.horizontalSpacing(),
                        Flexible(child: Text(news.ruleText)),
                      ],
                    ),
                  );
                },
              ),
            ),
            CustomElevatedBtn(
              onPressed: () {
                context.pushNamed(AppPages.liveQuiz);
              },
              text: 'आगे बढ़े',
            )
          ],
        ),
      ),
    );
  }
}
