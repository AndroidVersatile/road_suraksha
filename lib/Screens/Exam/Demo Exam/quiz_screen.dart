import 'dart:async';

import 'package:flutter/cupertino.dart';
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

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

// class _QuizScreenState extends State<QuizScreen> {
//   Timer? _timer;
//   int _timeLeft = 35;
//   var _questionIndex = 0;
//   var _totalScore = 0;
//   var data;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addPostFrameCallback(
//       (timeStamp) async {
//         data = await context.read<HomeProvider>().getDemoExamQuestion();
//         print(data); // context.read<HomeProvider>().getExamQuestion();
//       },
//     );
//     _startTimer();
//     super.initState();
//   }
//
//   void _startTimer() {
//     _timer?.cancel(); // Cancel any previous timer
//     _timeLeft = 35;
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_timeLeft > 0) {
//           _timeLeft--;
//         } else {
//           if (_questionIndex <
//               context.read<HomeProvider>().demoQuestionList.length - 1)
//             _nextQuestion();
//         }
//       });
//     });
//   }
//
//   void _answerQuestion(int score) {
//     _totalScore += score;
//     if (_questionIndex <
//         context.read<HomeProvider>().demoQuestionList.length - 1) {
//       Future.delayed(const Duration(seconds: 1), () {
//         _nextQuestion();
//       });
//     }
//   }
//
//   void _nextQuestion() {
//     if (_timer != null) {
//       _timer!.cancel();
//     }
//
//     if (_questionIndex <
//         context.read<HomeProvider>().demoQuestionList.length - 1) {
//       // Move to the next question if there are more questions left
//       setState(() {
//         _questionIndex++;
//         _startTimer(); // Restart timer for the next question
//       });
//     } else {
//       // Navigate to result screen once all questions are answered
//       context.pushNamed(
//         AppPages.result,
//         // Assuming AppPages.result is the name of the result page
//         pathParameters: {
//           "score": _totalScore.toString(),
//           // Passing the total score to result page
//         },
//       );
//     }
//   }
//
//   void _resetQuiz() {
//     _timer?.cancel();
//     setState(() {
//       _questionIndex = 0;
//       _totalScore = 0;
//       _startTimer();
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<HomeProvider>(context);
//
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         body: Container(
//           decoration: const BoxDecoration(
//               image: DecorationImage(
//             image: AssetImage(
//               Assets.homeBG,
//             ),
//             fit: BoxFit.fill,
//           )),
//           child: Column(
//             children: [
//               AppTheme.verticalSpacing(mul: 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     Assets.appLogo,
//                     height: 50,
//                     width: 50,
//                     fit: BoxFit.fill,
//                   ),
//                   Text(
//                     CommonText.appName,
//                     textAlign: TextAlign.center,
//                     style: context.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF850000),
//                     ),
//                   )
//                 ],
//               ),
//               Container(
//                   margin: AppTheme.boxPadding * 1.2,
//                   padding: AppTheme.boxPadding,
//                   height: context.screenHeight - 120,
//                   decoration: BoxDecoration(
//                     color: Colors.black12,
//                     borderRadius: BorderRadius.circular(AppTheme.radius),
//                   ),
//                   width: context.screenWidth,
//                   child: data == null
//                       ? const Center(child: CircularProgressIndicator())
//                       : data['Status'] == 'False'
//                           ? Container(
//                               alignment: Alignment.center,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     data['Message'],
//                                     style: context.textTheme.titleLarge,
//                                   ),
//                                   AppTheme.verticalSpacing(mul: 2),
//                                   CustomElevatedBtn(
//                                       onPressed: () {
//                                         context.pop();
//                                         context.pop();
//                                       },
//                                       text: 'OK'),
//                                 ],
//                               ),
//                             )
//                           : Quiz(
//                               answerQuestion: _answerQuestion,
//                               questionIndex: _questionIndex,
//                               questions: provider.demoQuestionList,
//                               timeLeft: _timeLeft,
//                               totalScore: _totalScore,
//                             )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Quiz extends StatelessWidget {
//   final List<QuizModel> questions;
//   final int questionIndex;
//   final Function answerQuestion;
//   final int timeLeft; // New timer property
//   final int totalScore; // New timer property
//   Quiz({
//     required this.questions,
//     required this.answerQuestion,
//     required this.questionIndex,
//     required this.timeLeft,
//     required this.totalScore,
//   });
//
//   var questionDetail;
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Text(
//             'Question No. ${questionIndex + 1}/${questions.length}',
//             style: context.textTheme.labelLarge?.copyWith(
//               color: Colors.orange,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           AppTheme.verticalSpacing(),
//           Container(
//             padding: AppTheme.boxPadding,
//             alignment: Alignment.center,
//             height: 250,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(AppTheme.radius),
//                 image: const DecorationImage(
//                   image: AssetImage(
//                     Assets.quiz,
//                   ),
//                   fit: BoxFit.fill,
//                 )),
//             child: Question(
//               questions[questionIndex].question,
//             ),
//           ),
//           AppTheme.verticalSpacing(),
//           Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: LinearProgressIndicator(
//                   value: timeLeft / 35,
//                   // The value ranges from 0.0 to 1.0
//                   backgroundColor: Colors.grey[300],
//                   color: Colors.orange,
//                   minHeight: 10,
//                   borderRadius: BorderRadius.circular(AppTheme.radius),
//                 ),
//               ),
//               Text(
//                 ' 00:$timeLeft', // Display the remaining time
//                 style: context.textTheme.labelLarge?.copyWith(
//                   color: Colors.red,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           AppTheme.verticalSpacing(),
//           ...(questions[questionIndex].getOptions()).map((option) {
//             return OptionButton(
//               answer: questions[questionIndex].questionAttemptedAnswerDemo,
//               onTap: (timeLeft == 0 ||
//                       questions[questionIndex]
//                           .questionAttemptedAnswerDemo
//                           .isNotEmpty)
//                   ? () {
//                       ErrorUtils.showSuccessSnackBar(
//                           'already attempt question !!');
//                     }
//                   : () {
//                       questions[questionIndex].questionAttemptedAnswerDemo =
//                           '${option['index']}';
//                       answerQuestion(questions[questionIndex].questionAnswer ==
//                               option['index']
//                           ? int.parse(questions[questionIndex].questionMarks)
//                           : 0);
//                     },
//               optionText: '${option['text']}',
//               optionIndex: '${option['index']}',
//             );
//           }).toList(),
//           if (questionIndex ==
//               context.read<HomeProvider>().demoQuestionList.length - 1)
//             CustomElevatedBtn(
//               onPressed: timeLeft == 0
//                   ? () {}
//                   : () async {
//                       String questionList = "";
//                       // Assuming we are using a list of maps to represent exam questions
//                       for (int j = 0; j < questions.length; j++) {
//                         var question = questions[j];
//                         String asd = question.questionAnswer
//                             .trim()
//                             .replaceAll("'", "''");
//                         // Create the SQL insert statement
//                         questionDetail =
//                             """insert into M_EmployeeAttempedQuestionsDemo(
//     EmpID, Subject, Exam, QuestionID, Question, OptionA, OptionB, OptionC, OptionD, OptionE, OptionF,
//     QuestionAnswer, QuestionAttemptedAnswer, QuestionDisplayTime, QuestionMarks, IsSeen, QImage, AImage,
//     BImage, CImage, DImage, EImage, FImage, isImage, ExamDetail, NagetiveMarks)
//   select ${question.studentId},
//     ${question.subject},
//    ${question.exam},
//     ${question.questionId},
//     N'${question.question.trim().replaceAll("'", "''")}',
//     N'${question.optionA.trim().replaceAll("'", "''")}',
//     N'${question.optionB.trim().replaceAll("'", "''")}',
//     N'${question.optionC.trim().replaceAll("'", "''")}',
//     N'${question.optionD.trim().replaceAll("'", "''")}',
//     N'${question.optionE.trim().replaceAll("'", "''")}',
//     N'${question.optionF.trim().replaceAll("'", "''")}',
//     '${question.questionAnswer}',
//     '${question.questionAttemptedAnswerDemo.trim().replaceAll("'", "''")}',
//     0,
//     ${question.questionMarks.trim().replaceAll("'", "''")},
//     'N',
//     'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${question.qImage.trim().replaceAll("'", "''")}',
//     'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${question.aImage.trim().replaceAll("'", "''")}',
//     'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${question.bImage.trim().replaceAll("'", "''")}',
//     'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${question.cImage.trim().replaceAll("'", "''")}',
//     'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${question.dImage.trim().replaceAll("'", "''")}',
//     'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${question.eImage.trim().replaceAll("'", "''")}',
//     'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${question.fImage.trim().replaceAll("'", "''")}',
//     '${question.isImage.trim().replaceAll("'", "''")}',
//     '${question.refNo.trim().replaceAll("'", "''")}',
//     '0';
//   """;
//
//                         print("QuestionDetail: $questionDetail");
//                         questionList += questionDetail;
//                       }
//                       print(questionList);
//                       var questionData =
//                           "UPDATE M_EmployeeAttempedQuestionsDemo set ActiveStatus='N' where Subject=" +
//                               '${questions[questionIndex].subject}' +
//                               " and Exam=" +
//                               '${questions[questionIndex].exam}' +
//                               " and EmpID=" +
//                               '${questions[questionIndex].studentId}' +
//                               ";";
//                       print("QuestionData: $questionData");
//                       var res = await context
//                           .read<HomeProvider>()
//                           .submitDemoQuiz(
//                               refNo: questions[questionIndex].refNo,
//                               examId: questions[questionIndex].exam,
//                               questionDetail: questionData + questionList);
//                       if (res == 200) {
//                         context.pushNamed(
//                           AppPages.result,
//                           // Assuming AppPages.result is the name of the result page
//                           pathParameters: {
//                             "score": totalScore.toString(),
//                             // Passing the total score to result page
//                           },
//                         );
//                       }
//                     },
//               text: 'Submit',
//             )
//         ],
//       ),
//     );
//   }
// }
//
// class Question extends StatelessWidget {
//   final String questionText;
//
//   Question(this.questionText, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.all(10),
//       child: Text(
//         questionText,
//         style: context.textTheme.titleMedium?.copyWith(
//           color: Colors.black,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;
  int _timeLeft = 35;
  var _questionIndex = 0;
  var _totalScore = 0;
  var data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      data = await context.read<HomeProvider>().getDemoExamQuestion();
      print(data);
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 35;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          if (_questionIndex <
              context.read<HomeProvider>().demoQuestionList.length - 1) {
            _nextQuestion();
          }
        }
      });
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    if (_questionIndex <
        context.read<HomeProvider>().demoQuestionList.length - 1) {
      Future.delayed(const Duration(seconds: 1), () {
        _nextQuestion();
      });
    }
  }

  void _nextQuestion() {
    _timer?.cancel();
    if (_questionIndex <
        context.read<HomeProvider>().demoQuestionList.length - 1) {
      setState(() {
        _questionIndex++;
        _startTimer();
      });
    } else {
      context.pushNamed(
        AppPages.result,
        pathParameters: {"score": _totalScore.toString()},
      );
    }
  }

  void _resetQuiz() {
    _timer?.cancel();
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);

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
                  Image.asset(Assets.appLogo, height: 50, width: 50, fit: BoxFit.fill),
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
                    : data['Status'] == 'False'
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(data['Message'], style: context.textTheme.titleLarge),
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
                    : Quiz(
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex,
                  questions: provider.demoQuestionList,
                  timeLeft: _timeLeft,
                  totalScore: _totalScore,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Quiz extends StatelessWidget {
  final List<QuizModel> questions;
  final int questionIndex;
  final Function answerQuestion;
  final int timeLeft;
  final int totalScore;

  Quiz({
    required this.questions,
    required this.answerQuestion,
    required this.questionIndex,
    required this.timeLeft,
    required this.totalScore,
  });

  var questionDetail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Question No. ${questionIndex + 1}/${questions.length}',
            style: context.textTheme.labelLarge?.copyWith(color: Colors.orange),
            textAlign: TextAlign.center,
          ),
          AppTheme.verticalSpacing(),
          // Container(
          //   padding: AppTheme.boxPadding,
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(AppTheme.radius),
          //     image: const DecorationImage(
          //       image: AssetImage(Assets.quiz),
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          //   child: Question(
          //     questions[questionIndex].question,
          //     questions[questionIndex].qImage, // Pass qImage here
          //   ),
          // ),


          Container(
            padding: AppTheme.boxPadding,
            alignment: Alignment.center,
            height: 200, // thoda chhota, adjust kar sakte ho
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              color: Colors.transparent, // background ko transparent ya white hata diya
            ),
            child: Column(
              children: [
                if (questions[questionIndex].qImage.isNotEmpty)
                  Container(
                    height: 120, // image height
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'http://rajsadaksuraksha.versatileitsolution.com/QuestionImages/${questions[questionIndex].qImage}',
                        fit: BoxFit.contain, // image overflow nahi hoga
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
                style: context.textTheme.labelLarge?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          AppTheme.verticalSpacing(),
          ...(questions[questionIndex].getOptions()).map((option) {
            return OptionButton(
              answer: questions[questionIndex].questionAttemptedAnswerDemo,
              onTap: (timeLeft == 0 ||
                  questions[questionIndex].questionAttemptedAnswerDemo.isNotEmpty)
                  ? () {
                ErrorUtils.showSuccessSnackBar('already attempt question !!');
              }
                  : () {
                questions[questionIndex].questionAttemptedAnswerDemo =
                '${option['index']}';
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
          if (questionIndex == context.read<HomeProvider>().demoQuestionList.length - 1)
            CustomElevatedBtn(
              onPressed: timeLeft == 0
                  ? () {}
                  : () async {
                String questionList = "";
                for (int j = 0; j < questions.length; j++) {
                  var question = questions[j];
                  String asd = question.questionAnswer.trim().replaceAll("'", "''");
                  questionDetail =
                  """insert into M_EmployeeAttempedQuestionsDemo(
                          EmpID, Subject, Exam, QuestionID, Question, OptionA, OptionB, OptionC, OptionD, OptionE, OptionF, 
                          QuestionAnswer, QuestionAttemptedAnswer, QuestionDisplayTime, QuestionMarks, IsSeen, QImage, AImage, 
                          BImage, CImage, DImage, EImage, FImage, isImage, ExamDetail, NagetiveMarks)
                          select ${question.studentId},
                          ${question.subject}, 
                          ${question.exam},
                          ${question.questionId},
                          N'${question.question.trim().replaceAll("'", "''")}',
                          N'${question.optionA.trim().replaceAll("'", "''")}',
                          N'${question.optionB.trim().replaceAll("'", "''")}',
                          N'${question.optionC.trim().replaceAll("'", "''")}',
                          N'${question.optionD.trim().replaceAll("'", "''")}',
                          N'${question.optionE.trim().replaceAll("'", "''")}',
                          N'${question.optionF.trim().replaceAll("'", "''")}',
                          '${question.questionAnswer}',
                          '${question.questionAttemptedAnswerDemo.trim().replaceAll("'", "''")}',
                          0,
                          ${question.questionMarks.trim().replaceAll("'", "''")},
                          'N',
                          '${question.qImage.trim().replaceAll("'", "''")}',
                          '${question.aImage.trim().replaceAll("'", "''")}',
                          '${question.bImage.trim().replaceAll("'", "''")}',
                          '${question.cImage.trim().replaceAll("'", "''")}',
                          '${question.dImage.trim().replaceAll("'", "''")}',
                          '${question.eImage.trim().replaceAll("'", "''")}',
                          '${question.fImage.trim().replaceAll("'", "''")}',
                          '${question.isImage.trim().replaceAll("'", "''")}',
                          '${question.refNo.trim().replaceAll("'", "''")}',
                          '0';
                        """;

                  questionList += questionDetail;
                }

                var questionData =
                    "UPDATE M_EmployeeAttempedQuestionsDemo set ActiveStatus='N' where Subject=${questions[questionIndex].subject} and Exam=${questions[questionIndex].exam} and EmpID=${questions[questionIndex].studentId};";

                var res = await context.read<HomeProvider>().submitDemoQuiz(
                  refNo: questions[questionIndex].refNo,
                  examId: questions[questionIndex].exam,
                  questionDetail: questionData + questionList,
                );
                if (res == 200) {
                  context.pushNamed(
                    AppPages.result,
                    pathParameters: {"score": totalScore.toString()},
                  );
                }
              },
              text: 'Submit',
            )
        ],
      ),
    );
  }
}

class Question extends StatelessWidget {
  final String questionText;
  final String qImage;

  Question(this.questionText, this.qImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          child: Text(
            questionText,
            style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        if (qImage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              qImage,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
              const Text('Image not available'),
            ),
          ),
      ],
    );
  }
}



// class OptionButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final String optionText;
//   final String optionIndex;
//   final String answer;
//
//   OptionButton(
//       {super.key,
//       required this.onTap,
//       required this.optionText,
//       required this.optionIndex,
//       required this.answer});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: AppTheme.boxPadding,
//         height: 50,
//         alignment: Alignment.centerLeft,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(AppTheme.radius),
//             border: Border.all(color: Colors.grey),
//             color: answer == optionIndex ? Colors.grey.shade200 : Colors.white),
//         margin: AppTheme.boxPadding,
//         child: Row(
//           children: [
//             CircleAvatar(child: Text(optionIndex)),
//             AppTheme.horizontalSpacing(),
//             Text(optionText),
//           ],
//         ),
//       ),
//     );
//   }
// }
class OptionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String optionText;
  final String optionIndex;
  final String answer;

  const OptionButton({
    super.key,
    required this.onTap,
    required this.optionText,
    required this.optionIndex,
    required this.answer,
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
          maxHeight: 120, // Max height set ki hai, scroll isi ke andar hoga
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
    );
  }
}

class Result extends StatelessWidget {
  final int resultScore;

  // final Function resetHandler;

  Result(
    this.resultScore,
    // this.resetHandler,
  );

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
    var provider = Provider.of<HomeProvider>(context);
    var resultData = provider.resultExamDetail.first;

    var data = [
      _ChartData('Total', 5),
      _ChartData('Right', resultScore.toDouble()),
      _ChartData('Wrong', 5.0 - resultScore.toDouble()),
      _ChartData('Others', 52)
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.go(AppPages.home);
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              Assets.homeBG,
            ),
            fit: BoxFit.fill,
          )),
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
                      color: Color(0xFF850000),

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Lottie.asset(
                      Assets.congrats,
                      repeat: false,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Question',
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          '${resultData.total}',
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    LinearProgressIndicator(
                      value: resultData.total.toDouble(),
                      // The value ranges from 0.0 to 1.0
                      backgroundColor: Colors.grey[300],
                      color: Colors.orange,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(AppTheme.radius),
                    ),
                    AppTheme.verticalSpacing(mul: 2),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Right',
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          '${resultData.rightAnswered}',
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    LinearProgressIndicator(
                      value: resultData.rightAnswered.toDouble() /
                          resultData.total,
                      // The value ranges from 0.0 to 1.0
                      backgroundColor: Colors.grey[300],
                      color: Colors.orange,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(AppTheme.radius),
                    ),
                    AppTheme.verticalSpacing(mul: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Wrong',
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          '${resultData.wrong}',
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    LinearProgressIndicator(
                      value: resultData.wrong / resultData.total,
                      // The value ranges from 0.0 to 1.0
                      backgroundColor: Colors.grey[300],
                      color: Colors.orange,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(AppTheme.radius),
                    ),
                    AppTheme.verticalSpacing(mul: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Seen',
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          '${resultData.total}',
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    LinearProgressIndicator(
                      value: 5,
                      // The value ranges from 0.0 to 1.0
                      backgroundColor: Colors.grey[300],
                      color: Colors.orange,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(AppTheme.radius),
                    ),
                    AppTheme.verticalSpacing(mul: 5),
                    // Text(
                    //   resultPhrase,
                    //   style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    //   textAlign: TextAlign.center,
                    // ),
                    // Text(
                    //   'Your score is: $resultScore',
                    //   style: TextStyle(fontSize: 22),
                    //   textAlign: TextAlign.center,
                    // ),
                    // FlatButton(
                    //   child: Text(
                    //     'Restart Quiz',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    //   textColor: Colors.blue,
                    //   onPressed: resetHandler,
                    // ),
                    ///
                    // SfCircularChart(
                    //     title: ChartTitle(
                    //         // text: 'Result',
                    //         ),
                    //     legend: Legend(
                    //         isVisible: true,
                    //         alignment: ChartAlignment.near,
                    //         overflowMode: LegendItemOverflowMode.wrap,
                    //         position: LegendPosition.bottom),
                    //     series: <CircularSeries>[
                    //       // Renders radial bar chart
                    //       RadialBarSeries<_ChartData, String>(
                    //         maximumValue: 5,
                    //         enableTooltip: true,
                    //         gap: '10%',
                    //         legendIconType: LegendIconType.seriesType,
                    //         cornerStyle: CornerStyle.endCurve,
                    //         radius: '100%',
                    //         innerRadius: '50%',
                    //         // dataLabelSettings: DataLabelSettings(
                    //         //   labelAlignment: ChartDataLabelAlignment.bottom,
                    //         //   // Renders the data label
                    //         // ),
                    //         useSeriesColor: true,
                    //         trackOpacity: 0.3,
                    //         dataSource: data,
                    //         xValueMapper: (_ChartData data, _) => data.x,
                    //         yValueMapper: (_ChartData data, _) => data.y,
                    //       )
                    //     ]),

                    CustomElevatedBtn(
                      onPressed: () {
                        context.pushNamed(AppPages.certificate,
                            pathParameters: {
                              "percentage": "${resultScore * 20}"
                            });
                      },
                      text: 'Certificate',
                    ),
                  ],
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
