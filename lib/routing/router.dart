import 'package:flutter/material.dart';
import 'package:gauvigyaan/Screens/Exam/Live%20Exam/live_quiz_screen.dart';
import 'package:go_router/go_router.dart';
import '../Screens/Exam/Demo Exam/cerificate.dart';
import '../Screens/Exam/Demo Exam/instruction_list_screen.dart';
import '../Screens/Exam/Demo Exam/quiz_screen.dart';

import '../Screens/Exam/Live Exam/live_cerificate.dart';
import '../Screens/Exam/Live Exam/live_instruction_list_screen.dart';
import '../Screens/Home/certificate_list_screen.dart';
import '../Screens/Home/feedback_screen.dart';
import '../Screens/Home/profile_screen.dart';
import '../Screens/Login/register_screen.dart';
import '../Screens/News/different_news_screen.dart';
import '../Screens/News/gau_vigyaan_books.dart';
import '../Screens/News/other_news_screen.dart';
import '../Screens/Home/home.dart';
import '../Screens/News/latest_news_screen.dart';
import '../Screens/Login/login_screen.dart';
import '../Screens/Login/splash.dart';
import '../Screens/rules.dart';
import '../widgets/pdf_viewer_screen.dart';
import 'app_pages.dart';

GoRouter buildRouter(BuildContext context, String initialRoute) {
  final router = GoRouter(
    initialLocation: initialRoute,
    debugLogDiagnostics: true,
    routes: [
      ///common routes

      GoRoute(
        path: AppPages.splashPath,
        name: AppPages.splashPath,
        builder: (context, state) {
          return SplashScreen();
        },
      ),

      GoRoute(
        path: AppPages.login,
        name: AppPages.login,
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: AppPages.rule,
        name: AppPages.rule,
        builder: (context, state) {
          return ActivityRulesScreen();
        },
      ),
      GoRoute(
        path: AppPages.qrScreen,
        name: AppPages.qrScreen,
        builder: (context, state) {
          return QrScreen();
        },
      ),
      GoRoute(
        path: AppPages.register,
        name: AppPages.register,
        builder: (context, state) {
          return RegisterScreen();
        },
      ),
      GoRoute(
        path: AppPages.home,
        name: AppPages.home,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppPages.profile,
        name: AppPages.profile,
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: AppPages.gauVigyaanBooks,
        name: AppPages.gauVigyaanBooks,
        builder: (context, state) {
          return GauVigyaanBooks();
        },
      ),
      GoRoute(
        path: AppPages.pdfViewer,
        name: AppPages.pdfViewer,
        builder: (context, state) {
          return PdfViewerScreen();
        },
      ),
      GoRoute(
        path: AppPages.certificateList,
        name: AppPages.certificateList,
        builder: (context, state) {
          return CertificateListScreen();
        },
      ),
      GoRoute(
        path: AppPages.liveCertificateList,
        name: AppPages.liveCertificateList,
        builder: (context, state) {
          return ViewLiveCertificateScreen();
        },
      ),
      GoRoute(
        path: AppPages.demoCertificateList,
        name: AppPages.demoCertificateList,
        builder: (context, state) {
          return ViewDemoCertificateList();
        },
      ),
      GoRoute(
        path: AppPages.latestNews,
        name: AppPages.latestNews,
        builder: (context, state) {
          return LatestNewsScreen();
        },
      ),
      GoRoute(
        path: AppPages.differentNews,
        name: AppPages.differentNews,
        builder: (context, state) {
          return DifferentNewsScreen();
        },
      ),
      GoRoute(
        path: AppPages.otherNews,
        name: AppPages.otherNews,
        builder: (context, state) {
          return OtherNewsScreen();
        },
      ),
      GoRoute(
        path: AppPages.feedback,
        name: AppPages.feedback,
        builder: (context, state) {
          return FeedbackScreen();
        },
      ),
      GoRoute(
        path: AppPages.instruction,
        name: AppPages.instruction,
        builder: (context, state) {
          String type = state.pathParameters['type'] ?? '';
          return InstructionListScreen(
            type: type,
          );
        },
      ),
      GoRoute(
        path: AppPages.quiz,
        name: AppPages.quiz,
        builder: (context, state) {
          return QuizScreen();
        },
      ),
      GoRoute(
        path: '${AppPages.certificate}/:percentage',
        name: AppPages.certificate,
        builder: (context, state) {
          String score = state.pathParameters['percentage'] ?? '';
          return CertificateScreen(score: score);
        },
      ),

      GoRoute(
        path: '${AppPages.result}/:score',
        name: AppPages.result,
        builder: (context, state) {
          String score = state.pathParameters['score'] ?? '';
          return Result(int.parse(score));
        },
      ),

      ///LIVE EXAM
      GoRoute(
        path: AppPages.liveInstruction,
        name: AppPages.liveInstruction,
        builder: (context, state) {
          String type = state.pathParameters['type'] ?? '';
          return LiveInstructionListScreen(
            type: type,
          );
        },
      ),

      GoRoute(
        path: AppPages.liveQuiz,
        name: AppPages.liveQuiz,
        builder: (context, state) {
          return LiveQuizScreen();
        },
      ),

      GoRoute(
        path: '${AppPages.liveResult}/:score',
        name: AppPages.liveResult,
        builder: (context, state) {
          String score = state.pathParameters['score'] ?? '';
          return LiveResult(int.parse(score));
        },
      ),

      GoRoute(
        path: '${AppPages.liveCertificate}/:percentage',
        name: AppPages.liveCertificate,
        builder: (context, state) {
          String score = state.pathParameters['percentage'] ?? '';
          return LiveCertificateScreen(score: score);
        },
      ),
    ],
  );
  return router;
}
