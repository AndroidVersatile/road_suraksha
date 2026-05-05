import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gauvigyaan/model/quiz_model.dart';
import 'package:gauvigyaan/providers/home_provider.dart';
import 'package:gauvigyaan/routing/app_pages.dart';
import 'package:gauvigyaan/widgets/button.dart';
import 'package:gauvigyaan/widgets/error_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/assets.dart';
import '../../../constants/common_text.dart';
import '../../../theme/app_theme.dart';

class LiveQuizScreen extends StatefulWidget {
  const LiveQuizScreen({super.key});

  @override
  State<LiveQuizScreen> createState() => _LiveQuizScreenState();
}

class _LiveQuizScreenState extends State<LiveQuizScreen> {
  Timer? _timer;
  int _timeLeft = 35;
  int _questionIndex = 0;
  int _totalScore = 0;
  Map<String, dynamic>? data;
  
  // ✅ NEW: Query parts ko store karenge as we go
  final List<String> _queryParts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final result = await context.read<HomeProvider>().getExamQuestion();
        if (mounted) {
          setState(() {
            data = result;
          });
        }
      } catch (e) {
        print('Error loading questions: $e');
      }
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 35;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            if (_questionIndex < context.read<HomeProvider>().demoQuestionList.length - 1) {
              _nextQuestion();
            }
          }
        });
      }
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    if (_questionIndex < context.read<HomeProvider>().demoQuestionList.length - 1) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _nextQuestion();
      });
    }
  }

  // ✅ NEW: Build query for current question immediately
  void _buildCurrentQuestionQuery() {
    final provider = context.read<HomeProvider>();
    if (_questionIndex >= provider.demoQuestionList.length) return;
    
    final q = provider.demoQuestionList[_questionIndex];
    final question = q.question.replaceAll("'", "''");
    final optionA = q.optionA.replaceAll("'", "''");
    final optionB = q.optionB.replaceAll("'", "''");
    final optionC = q.optionC.replaceAll("'", "''");
    final optionD = q.optionD.replaceAll("'", "''");
    final optionE = q.optionE.replaceAll("'", "''");
    final optionF = q.optionF.replaceAll("'", "''");

    final queryPart = """
insert into M_EmployeeAttempedQuestions(
EmpID, Subject, Exam, QuestionID, Question,
OptionA, OptionB, OptionC, OptionD, OptionE, OptionF,
QuestionAnswer, QuestionAttemptedAnswer,
QuestionDisplayTime, QuestionMarks, IsSeen,
QImage, AImage, BImage, CImage, DImage, EImage, FImage,
isImage, ExamDetail, NagetiveMarks)
select
${q.studentId},
${q.subject},
${q.exam},
${q.questionId},
N'$question',
N'$optionA',
N'$optionB',
N'$optionC',
N'$optionD',
N'$optionE',
N'$optionF',
'${q.questionAnswer}',
'${q.questionAttemptedAnswerDemo}',
${35 - _timeLeft},
${q.questionMarks},
'N',
'${q.qImage}',
'${q.aImage}',
'${q.bImage}',
'${q.cImage}',
'${q.dImage}',
'${q.eImage}',
'${q.fImage}',
'${q.isImage}',
'${q.refNo}',
'0';
""";

    _queryParts.add(queryPart);
  }

  void _nextQuestion() {
    _timer?.cancel();
    
    // ✅ Current question ka query build karo (light operation)
    _buildCurrentQuestionQuery();

    if (_questionIndex < context.read<HomeProvider>().demoQuestionList.length - 1) {
      setState(() {
        _questionIndex++;
        _startTimer();
      });
    } else {
      context.pushNamed(
        AppPages.result,
        pathParameters: {
          "score": _totalScore.toString(),
        },
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.homeBG),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              AppTheme.verticalSpacing(mul: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.appLogo,
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    CommonText.appName,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF850000),
                    ),
                  )
                ],
              ),
              Container(
                margin: AppTheme.boxPadding * 1.2,
                padding: AppTheme.boxPadding,
                height: context.screenHeight - 120,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                width: context.screenWidth,
                child: data == null
                    ? const Center(child: CircularProgressIndicator())
                    : data!['Status'] == 'False'
                        ? Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data!['Message'],
                                  style: context.textTheme.titleLarge,
                                ),
                                AppTheme.verticalSpacing(mul: 2),
                                CustomElevatedBtn(
                                  onPressed: () {
                                    context.pop();
                                    context.pop();
                                  },
                                  text: 'OK',
                                ),
                              ],
                            ),
                          )
                        : LiveQuiz(
                            answerQuestion: _answerQuestion,
                            questionIndex: _questionIndex,
                            questions: provider.demoQuestionList,
                            timeLeft: _timeLeft,
                            totalScore: _totalScore,
                            queryParts: _queryParts, // ✅ Pass pre-built queries
                            onSubmit: () {
                              _timer?.cancel();
                              // Build last question's query
                              _buildCurrentQuestionQuery();
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiveQuiz extends StatefulWidget {
  final List<QuizModel> questions;
  final int questionIndex;
  final Function answerQuestion;
  final int timeLeft;
  final int totalScore;
  final VoidCallback onSubmit;
  final List<String> queryParts; // ✅ Pre-built query parts

  const LiveQuiz({
    super.key,
    required this.questions,
    required this.answerQuestion,
    required this.questionIndex,
    required this.timeLeft,
    required this.totalScore,
    required this.onSubmit,
    required this.queryParts,
  });

  @override
  State<LiveQuiz> createState() => _LiveQuizState();
}

class _LiveQuizState extends State<LiveQuiz> {
  bool _isSubmitting = false;

  Future<void> _handleSubmit() async {
    if (_isSubmitting || !mounted) return;

    setState(() => _isSubmitting = true);

    // Timer stop + build last query
    widget.onSubmit();

    // Loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Submitting...'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    try {
      // ✅ INSTANT - Just join pre-built strings!
      debugPrint('Joining ${widget.queryParts.length} query parts...');
      final questionList = widget.queryParts.join('\n');
      debugPrint('Query ready! Length: ${questionList.length}');

      final questionData =
          "UPDATE M_EmployeeAttempedQuestions set ActiveStatus='N' "
          "where Subject=${widget.questions[widget.questionIndex].subject} "
          "and Exam=${widget.questions[widget.questionIndex].exam} "
          "and EmpID=${widget.questions[widget.questionIndex].studentId};";

      if (!mounted) return;

      debugPrint('Submitting to API...');
      final res = await context
          .read<HomeProvider>()
          .submitLiveQuiz(
            refNo: widget.questions[widget.questionIndex].refNo,
            examId: widget.questions[widget.questionIndex].exam,
            questionDetail: questionData + questionList,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('API Response: $res');

      if (mounted) {
        Navigator.pop(context); // Dialog close

        if (res == 200) {
          context.pushNamed(
            AppPages.liveResult,
            pathParameters: {"score": widget.totalScore.toString()},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Submission failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } on TimeoutException {
      debugPrint('Timeout error');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request timeout. Please try again.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      debugPrint('Submit error: $e');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Question No. ${widget.questionIndex + 1}/${widget.questions.length}',
            style: context.textTheme.labelLarge?.copyWith(
              color: Colors.orange,
            ),
            textAlign: TextAlign.center,
          ),
          AppTheme.verticalSpacing(),

          // Question Container
          Container(
            padding: AppTheme.boxPadding,
            alignment: Alignment.center,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                if (widget.questions[widget.questionIndex].qImage.isNotEmpty)
                  Container(
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${widget.questions[widget.questionIndex].qImage}',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      widget.questions[widget.questionIndex].question,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppTheme.verticalSpacing(),

          // Timer
          Row(
            children: [
              Expanded(
                flex: 2,
                child: LinearProgressIndicator(
                  value: widget.timeLeft / 35,
                  backgroundColor: Colors.grey[300],
                  color: Colors.orange,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
              ),
              Text(
                ' 00:${widget.timeLeft}',
                style: context.textTheme.labelLarge?.copyWith(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          AppTheme.verticalSpacing(),

          // Options
          ...(widget.questions[widget.questionIndex].getOptions()).map((option) {
            return LiveOptionButton(
              answer: widget.questions[widget.questionIndex]
                  .questionAttemptedAnswerDemo,
              onTap: (widget.timeLeft == 0 ||
                      widget.questions[widget.questionIndex]
                          .questionAttemptedAnswerDemo
                          .isNotEmpty)
                  ? () {}
                  : () {
                      widget.questions[widget.questionIndex]
                          .questionAttemptedAnswerDemo = '${option['index']}';
                      widget.answerQuestion(
                        widget.questions[widget.questionIndex].questionAnswer ==
                                option['index']
                            ? int.parse(widget
                                .questions[widget.questionIndex].questionMarks)
                            : 0,
                      );
                    },
              optionText: '${option['text']}',
              optionIndex: '${option['index']}',
            );
          }).toList(),

          // Submit Button
          if (widget.questionIndex ==
              context.read<HomeProvider>().demoQuestionList.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CustomElevatedBtn(
                onPressed: _isSubmitting ? null : _handleSubmit,
                text: _isSubmitting ? 'Submitting...' : 'Submit',
              ),
            ),
        ],
      ),
    );
  }
}

class LiveQuestion extends StatelessWidget {
  final String questionText;
  final String? qImage;

  const LiveQuestion(this.questionText, this.qImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          if (qImage != null && qImage!.isNotEmpty)
            Container(
              height: 200,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  qImage!,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image));
                  },
                ),
              ),
            ),
          Text(
            questionText,
            style: context.textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LiveOptionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String optionText;
  final String optionIndex;
  final String answer;
  final String? optionImage;

  const LiveOptionButton({
    super.key,
    required this.onTap,
    required this.optionText,
    required this.optionIndex,
    required this.answer,
    this.optionImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppTheme.boxPadding,
        constraints: const BoxConstraints(
          minHeight: 50,
          maxHeight: 80,
        ),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: Colors.grey),
          color: answer == optionIndex ? Colors.grey.shade200 : Colors.white,
        ),
        margin: AppTheme.boxPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(child: Text(optionIndex)),
            AppTheme.horizontalSpacing(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (optionImage != null && optionImage!.isNotEmpty)
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Image.network(
                        optionImage!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        optionText,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveResult extends StatelessWidget {
  final int resultScore;

  const LiveResult(this.resultScore, {super.key});

  String get resultPhrase {
    String resultText;
    if (resultScore == 30) {
      resultText = 'You got everything right!';
    } else if (resultScore > 20) {
      resultText = 'Pretty good!';
    } else {
      resultText = 'You can do better!';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final resultData = provider.resultExamDetail.first;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppPages.home);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.homeBG),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              AppTheme.verticalSpacing(mul: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.appLogo,
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    CommonText.appName,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Container(
                margin: AppTheme.boxPadding * 1.2,
                padding: AppTheme.boxPadding,
                height: context.screenHeight - 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                width: context.screenWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Lottie.asset(
                        Assets.congrats,
                        repeat: false,
                      ),

                      // Total Questions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Question',
                              style: context.textTheme.titleMedium),
                          Text('${resultData.total}',
                              style: context.textTheme.titleMedium),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: 1.0,
                        backgroundColor: Colors.grey[300],
                        color: Colors.orange,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                      ),
                      AppTheme.verticalSpacing(mul: 2),

                      // Right Answers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Right', style: context.textTheme.titleMedium),
                          Text('${resultData.rightAnswered}',
                              style: context.textTheme.titleMedium),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: resultData.rightAnswered.toDouble() /
                            resultData.total,
                        backgroundColor: Colors.grey[300],
                        color: Colors.green,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                      ),
                      AppTheme.verticalSpacing(mul: 2),

                      // Wrong Answers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Wrong', style: context.textTheme.titleMedium),
                          Text('${resultData.wrong}',
                              style: context.textTheme.titleMedium),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: resultData.wrong / resultData.total,
                        backgroundColor: Colors.grey[300],
                        color: Colors.red,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                      ),
                      AppTheme.verticalSpacing(mul: 2),

                      // Seen
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Seen', style: context.textTheme.titleMedium),
                          Text('${resultData.total}',
                              style: context.textTheme.titleMedium),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: 1.0,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                      ),
                      AppTheme.verticalSpacing(mul: 5),

                      CustomElevatedBtn(
                        onPressed: () {
                          context.pushNamed(
                            AppPages.liveCertificate,
                            pathParameters: {"percentage": "${resultScore * 20}"},
                          );
                        },
                        text: 'Certificate',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  
  final String x;
  final double y;
}