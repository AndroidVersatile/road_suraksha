import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gauvigyaan/model/home_model.dart';
import 'package:gauvigyaan/model/quiz_model.dart';

import '../constants/api_urls.dart';
import '../constants/app_cache.dart';
import '../model/result_model.dart';
import '../services/app_services.dart';

class HomeProvider extends ChangeNotifier {
  bool loading = false;
  final _apiClient = APIService.ApiClient();
  final AppCache cache = AppCache();
  String userId = '';
  String shareAppMessage = '';
  List<SliderModel> sliderList = List.empty(growable: true);
  List<AboutGauMata> gauMataBooks = List.empty(growable: true);
  List<AboutGauMata> differentNews = List.empty(growable: true);
  List<OtherNewsModel> otherNews = List.empty(growable: true);
  List<LatestNewsModel> latestNews = List.empty(growable: true);
  List<LatestNewsModel> instructionList = List.empty(growable: true);
  List<QuizModel> demoQuestionList = List.empty(growable: true);
  List<LoadLiveExamModel> loadLiveExamModel = List.empty(growable: true);
  List<ExamDetail> resultExamDetail = List.empty(growable: true);
  List<LoadLiveExamModel> mainResultDetail = List.empty(growable: true);
  AboutGauMata? currentBookPdf;
  UserModel? userModel;
  String currentExamId = "";
  String currentSubjectId = "";

  getUserId() async {
    userId = await cache.getUserId();
  }

  Future<int> getSlider() async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();
    await getUserId();
    final response = await _apiClient.dio.get(
      ApiUrls.slider,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      sliderList = await List.castFrom(
          data['Data'].map((e) => SliderModel.fromJson(e)).toList());
      // userModel = UserProfile.fromJson(response.data[0]);
      // print(userModel);
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getLatestNews() async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();

    final response = await _apiClient.dio.get(
      ApiUrls.latestNews,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      latestNews = await List.castFrom(
          data['Data'].map((e) => LatestNewsModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getGauVigyaanBooks() async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();

    final response = await _apiClient.dio.get(
      ApiUrls.gouVigyaanBooks,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      gauMataBooks = await List.castFrom(
          data['AboutGauMata'].map((e) => AboutGauMata.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getDifferentNews() async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();

    final response = await _apiClient.dio.get(
      ApiUrls.differentNews,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      differentNews = await List.castFrom(
          data['AwardDetails'].map((e) => AboutGauMata.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getOtherNews() async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();

    final response = await _apiClient.dio.get(
      ApiUrls.otherNews,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      otherNews = await List.castFrom(
          data['Data'].map((e) => OtherNewsModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> sendFeedback({
    required String msg,
  }) async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();
    String type = base64.encode(utf8.encode('त्रुटि'));
    final response =
        await _apiClient.dio.get(ApiUrls.feedback, queryParameters: {
      "StudentID": userId,
      "Type": type,
      "Message": msg,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getUserDetails() async {
    loading = true;
    notifyListeners();
    var userId = await cache.getUserId();

    final response =
        await _apiClient.dio.get(ApiUrls.profile, queryParameters: {
      "StudentID": userId,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      var user = await List.castFrom(
          data['Data'].map((e) => UserModel.fromJson(e)).toList());
      userModel = user.first;
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  // Future<int> updateUserDetails() async {
  //   loading = true;
  //   notifyListeners();
  //   var userId = await cache.getUserId();
  //
  //   final response =
  //       await _apiClient.dio.get(ApiUrls.updateProfile, queryParameters: {
  //     "StudentID": userId,
  //   });
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.data);
  //     print(data);
  //     var user = await List.castFrom(
  //         data['Data'].map((e) => UserModel.fromJson(e)).toList());
  //     userModel = user.first;
  //   }
  //   loading = false;
  //   notifyListeners();
  //   return response.statusCode ?? 500;
  // }

  Future<int> submitDemoQuiz({
    required String refNo,
    required String examId,
    required String questionDetail,
  }) async {
    loading = true;
    notifyListeners();
    var userId = await cache.getUserId();
    Map<String, dynamic> body = {
      "ExamDetail": refNo,
      "Student": userId,
      "Exam": examId,
      "QuestionDetail": questionDetail,
    };
    final response = await _apiClient.dio.post(ApiUrls.submitQuestionDemo,
        data: body,
        options: Options(
          contentType:
              Headers.formUrlEncodedContentType, // x-www-form-urlencoded
        ));
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      resultExamDetail = await List.castFrom(
          data['ExamDetail'].map((e) => ExamDetail.fromJson(e)).toList());
      mainResultDetail = await List.castFrom(
          data['Main'].map((e) => Main.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> submitLiveQuiz({
    required String refNo,
    required String examId,
    required String questionDetail,
  }) async {
    loading = true;
    notifyListeners();
    var userId = await cache.getUserId();
    Map<String, dynamic> body = {
      "ExamDetail": refNo,
      "Student": userId,
      "Exam": examId,
      "QuestionDetail": questionDetail,
    };
    final response = await _apiClient.dio.post(ApiUrls.submitQuestion,
        data: body,
        options: Options(
          contentType:
              Headers.formUrlEncodedContentType, // x-www-form-urlencoded
        ));
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      resultExamDetail = await List.castFrom(
          data['ExamDetail'].map((e) => ExamDetail.fromJson(e)).toList());
      mainResultDetail = await List.castFrom(
          data['Main'].map((e) => Main.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getShareAppMessage() async {
    loading = true;
    notifyListeners();

    final response = await _apiClient.dio.get(
      ApiUrls.shareMessageAPI,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      shareAppMessage = data['Data'][0]['Message'];
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getExamInstruction() async {
    loading = true;

    notifyListeners();
// var userId = await cache.getUserId();

    final response = await _apiClient.dio.get(
      ApiUrls.instruction,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      instructionList = await List.castFrom(
          data['Data'].map((e) => LatestNewsModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> loadDemoExam() async {
    loading = true;

    notifyListeners();
// var userId = await cache.getUserId();

    final response =
        await _apiClient.dio.get(ApiUrls.loadExamDemo, queryParameters: {
      "SubjectID": userModel?.course,
      "StudentID": userId,
      "SchoolID": '0',
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      loadLiveExamModel = await List.castFrom(
          data['Data'].map((e) => LoadLiveExamModel.fromJson(e)).toList());
      currentExamId = loadLiveExamModel.first.examId;
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<dynamic> loadLiveExam() async {
    loading = true;

    notifyListeners();
// var userId = await cache.getUserId();

    final response =
        await _apiClient.dio.get(ApiUrls.loadExamLive, queryParameters: {
      "SubjectID": userModel?.course,
      "StudentID": userId,
      "SchoolID": '0',
    });
    var data = json.decode(response.data);
    print(data);
    if (data['Status'] == 'True') {
      loadLiveExamModel = await List.castFrom(
          data['Data'].map((e) => LoadLiveExamModel.fromJson(e)).toList());
      currentExamId = loadLiveExamModel.first.examId;
    }
    loading = false;
    notifyListeners();
    return data;
  }

  Future<dynamic> getDemoExamQuestion() async {
    loading = true;

    notifyListeners();
// var userId = await cache.getUserId();

    final response =
        await _apiClient.dio.get(ApiUrls.demoExam, queryParameters: {
      "Student": userId,
      "Exam": currentExamId,
      "WebsiteUrl": '',
    });
    var data = json.decode(response.data);
    if (data['Status'] == 'True') {
      print(data);
      demoQuestionList = await List.castFrom(
          data['Data'].map((e) => QuizModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return data;
  }

  Future<dynamic> getExamQuestion() async {
    loading = true;

    notifyListeners();
// var userId = await cache.getUserId();

    final response = await _apiClient.dio.get(ApiUrls.exam, queryParameters: {
      "Student": userId,
      "Exam": currentExamId,
      "WebsiteUrl": '',
    });
    var data = json.decode(response.data);
    if (data['Status'] == 'True') {
      print(data);
      demoQuestionList = await List.castFrom(
          data['Data'].map((e) => QuizModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return data;
  }

  List<DemoCertificateModel> demoCertificateModel = List.empty(growable: true);
  List<CertificateModel> certificateModel = List.empty(growable: true);

  Future<dynamic> getDemoCertificateList() async {
    loading = true;

    notifyListeners();
    var userId = await cache.getUserId();

    final response =
        await _apiClient.dio.get(ApiUrls.demoCertificate, queryParameters: {
      "Id": userId,
    });
    var data = json.decode(response.data);
    if (data['Status'] == 'True') {
      print(data);
      demoCertificateModel = await List.castFrom(
          data['Data'].map((e) => DemoCertificateModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return data;
  }

  Future<dynamic> getCertificateList() async {
    loading = true;

    notifyListeners();
    var userId = await cache.getUserId();

    final response =
        await _apiClient.dio.get(ApiUrls.liveCertificate, queryParameters: {
      "Id": userId,
    });
    var data = json.decode(response.data);
    if (data['Status'] == 'True') {
      print(data);
      certificateModel = await List.castFrom(
          data['Data'].map((e) => CertificateModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return data;
  }
}
