class ApiUrls {
  static const String baseUrl =
      'http://rajsadaksuraksha.versatileitsolution.com/webservice/webservice.asmx';
  static const String sliderImageUrl =
      'http://rajsadaksuraksha.versatileitsolution.com/';
  static const String login = '$baseUrl/AppLoginNew';
  static const String register = '$baseUrl/AppSignUpNewExam';
  static const String registerNew = '$baseUrl/AppSignUpNewExam_New';
  static const String state = '$baseUrl/LoadState';
  static const String classes = '$baseUrl/LoadBranch';
  static const String qrInstruction = '$baseUrl/GetPaymentInstruction';

  ///home
  static const String slider = '$baseUrl/SelectSliderImages';
  static const String profile = '$baseUrl/ViewProfile';
  static const String updateProfile = '$baseUrl/UpdateProfile_NewExam';
  static const String updateProfileNew = '$baseUrl/UpdateProfileNewExam';

  //news
  static const String latestNews = '$baseUrl/Select_ExamRule';
  static const String gouVigyaanBooks = '$baseUrl/Select_AboutGauMata';
  static const String differentNews = '$baseUrl/Select_AwardDetails';
  static const String otherNews = '$baseUrl/Select_AboutGauVigyanCategory';

//feedback
  static const String feedback = '$baseUrl/User_Feedback';
  static const String demoCertificate = '$baseUrl/SelectEmpExamCertificateDemo';
  static const String liveCertificate = '$baseUrl/SelectEmpExamCertificate';
  static const String shareMessageAPI = '$baseUrl/GetShareMessage';
  static const String ApplicationLink =
      'https://play.google.com/';

//exam
  static const String instruction = '$baseUrl/BVP_SelectRuleMaster ';

  static const String demoExam = '$baseUrl/LoadQuestionByExamDemo';
  static const String exam = '$baseUrl/LoadQuestionByExamNew';
  static const String qrCode = '$baseUrl/GetQRImages';
  static const String submitQuestionDemo = '$baseUrl/SubmitQuestionDemo';
  static const String submitQuestion = '$baseUrl/SubmitQuestion';

  ///Load Exam
  static const String loadExamDemo = '$baseUrl/LoadExamNewDemo';
  static const String loadExamLive = '$baseUrl/LoadExamNewExam';
}
