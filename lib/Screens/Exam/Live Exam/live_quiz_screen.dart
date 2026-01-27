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

// 🔥 Top-level function for compute() - Class ke bahar hona chahiye
String buildLiveQuizQuery(Map<String, dynamic> data) {
  final List<dynamic> questionsJson = data['questions'];
  final int timeLeft = data['timeLeft'];

  final buffer = StringBuffer();

  for (final q in questionsJson) {
    final question = q['question']?.toString().replaceAll("'", "''") ?? '';
    final optionA = q['optionA']?.toString().replaceAll("'", "''") ?? '';
    final optionB = q['optionB']?.toString().replaceAll("'", "''") ?? '';
    final optionC = q['optionC']?.toString().replaceAll("'", "''") ?? '';
    final optionD = q['optionD']?.toString().replaceAll("'", "''") ?? '';
    final optionE = q['optionE']?.toString().replaceAll("'", "''") ?? '';
    final optionF = q['optionF']?.toString().replaceAll("'", "''") ?? '';

    buffer.write("""
insert into M_EmployeeAttempedQuestions(
EmpID, Subject, Exam, QuestionID, Question,
OptionA, OptionB, OptionC, OptionD, OptionE, OptionF,
QuestionAnswer, QuestionAttemptedAnswer,
QuestionDisplayTime, QuestionMarks, IsSeen,
QImage, AImage, BImage, CImage, DImage, EImage, FImage,
isImage, ExamDetail, NagetiveMarks)
select
${q['studentId']},
${q['subject']},
${q['exam']},
${q['questionId']},
N'$question',
N'$optionA',
N'$optionB',
N'$optionC',
N'$optionD',
N'$optionE',
N'$optionF',
'${q['questionAnswer'] ?? ''}',
'${q['attempted'] ?? ''}',
${35 - timeLeft},
${q['marks'] ?? 0},
'N',
'${q['qImage'] ?? ''}',
'${q['aImage'] ?? ''}',
'${q['bImage'] ?? ''}',
'${q['cImage'] ?? ''}',
'${q['dImage'] ?? ''}',
'${q['eImage'] ?? ''}',
'${q['fImage'] ?? ''}',
'${q['isImage'] ?? ''}',
'${q['refNo'] ?? ''}',
'0';
""");
  }

  return buffer.toString();
}

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

  void _nextQuestion() {
    _timer?.cancel();

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
                            onSubmit: () {
                              _timer?.cancel();
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

class LiveQuiz extends StatelessWidget {
  final List<QuizModel> questions;
  final int questionIndex;
  final Function answerQuestion;
  final int timeLeft;
  final int totalScore;
  final VoidCallback onSubmit;

  const LiveQuiz({
    super.key,
    required this.questions,
    required this.answerQuestion,
    required this.questionIndex,
    required this.timeLeft,
    required this.totalScore,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Question No. ${questionIndex + 1}/${questions.length}',
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
                if (questions[questionIndex].qImage.isNotEmpty)
                  Container(
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${questions[questionIndex].qImage}',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      questions[questionIndex].question,
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
                  value: timeLeft / 35,
                  backgroundColor: Colors.grey[300],
                  color: Colors.orange,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
              ),
              Text(
                ' 00:$timeLeft',
                style: context.textTheme.labelLarge?.copyWith(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          AppTheme.verticalSpacing(),
          
          // Options
          ...(questions[questionIndex].getOptions()).map((option) {
            return LiveOptionButton(
              answer: questions[questionIndex].questionAttemptedAnswerDemo,
              onTap: (timeLeft == 0 ||
                      questions[questionIndex].questionAttemptedAnswerDemo.isNotEmpty)
                  ? () {}
                  : () {
                      questions[questionIndex].questionAttemptedAnswerDemo = '${option['index']}';
                      answerQuestion(
                        questions[questionIndex].questionAnswer == option['index']
                            ? int.parse(questions[questionIndex].questionMarks)
                            : 0,
                      );
                    },
              optionText: '${option['text']}',
              optionIndex: '${option['index']}',
            );
          }).toList(),
          
          // Submit Button
          if (questionIndex == context.read<HomeProvider>().demoQuestionList.length - 1)
            CustomElevatedBtn(
              onPressed: () async {
                if (!context.mounted) return;

                // Timer stop
                onSubmit();

                // Loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  // ✅ Questions ko JSON format mein convert karo
                  final questionsJson = questions.map((q) {
                    return {
                      'studentId': q.studentId,
                      'subject': q.subject,
                      'exam': q.exam,
                      'questionId': q.questionId,
                      'question': q.question,
                      'optionA': q.optionA,
                      'optionB': q.optionB,
                      'optionC': q.optionC,
                      'optionD': q.optionD,
                      'optionE': q.optionE,
                      'optionF': q.optionF,
                      'questionAnswer': q.questionAnswer,
                      'attempted': q.questionAttemptedAnswerDemo,
                      'marks': q.questionMarks,
                      'qImage': q.qImage,
                      'aImage': q.aImage,
                      'bImage': q.bImage,
                      'cImage': q.cImage,
                      'dImage': q.dImage,
                      'eImage': q.eImage,
                      'fImage': q.fImage,
                      'isImage': q.isImage,
                      'refNo': q.refNo,
                    };
                  }).toList();

                  // ✅ Background thread mein query build karo
                  final questionList = await compute(
                    buildLiveQuizQuery,
                    {
                      "questions": questionsJson,
                      "timeLeft": timeLeft,
                    },
                  );

                  final questionData =
                      "UPDATE M_EmployeeAttempedQuestions set ActiveStatus='N' "
                      "where Subject=${questions[questionIndex].subject} "
                      "and Exam=${questions[questionIndex].exam} "
                      "and EmpID=${questions[questionIndex].studentId};";

                  if (!context.mounted) return;

                  final res = await context
                      .read<HomeProvider>()
                      .submitLiveQuiz(
                        refNo: questions[questionIndex].refNo,
                        examId: questions[questionIndex].exam,
                        questionDetail: questionData + questionList,
                      )
                      .timeout(const Duration(seconds: 30));

                  if (context.mounted) {
                    Navigator.pop(context); // Dialog close

                    if (res == 200) {
                      context.pushNamed(
                        AppPages.liveResult,
                        pathParameters: {"score": totalScore.toString()},
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
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request timeout. Please try again.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  debugPrint('Submit error: $e');
                }
              },
              text: 'Submit',
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
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
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
                          Text('Total Question', style: context.textTheme.titleMedium),
                          Text('${resultData.total}', style: context.textTheme.titleMedium),
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
                          Text('${resultData.rightAnswered}', style: context.textTheme.titleMedium),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: resultData.rightAnswered.toDouble() / resultData.total,
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
                          Text('${resultData.wrong}', style: context.textTheme.titleMedium),
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
                          Text('${resultData.total}', style: context.textTheme.titleMedium),
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