import 'dart:convert';
import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gauvigyaan/model/register_model.dart';
import 'package:gauvigyaan/widgets/date_utils.dart';

import '../constants/api_urls.dart';
import '../constants/app_cache.dart';
import '../model/api_response.dart';
import '../model/device_info_model.dart';
import '../model/home_model.dart';
import '../services/app_services.dart';
import '../services/notification_service.dart';

class LoginProvider extends ChangeNotifier {
  int userId = 0;
  String userImagePath='';
  List<StateModel> stateList = List.empty(growable: true);
  List<GroupModel> groupList = List.empty(growable: true);
  List<QRInstructionModel> qrInstructionList = List.empty(growable: true);
  String qrCode = '';
  bool loading = false;
  final _apiClient = APIService.ApiClient();
  final AppCache cache = AppCache();
  String currentState = "";
  String currentDistrict = "";
  NotificationService notificationService = NotificationService();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  DeviceInfoModel? deviceInfoModel;
  String _fcmToken = '';
  UserModel? userModel;

  String get fcmToken => _fcmToken;

  set fcmToken(String value) {
    _fcmToken = value;
    notifyListeners();
  }

  LoginProvider() {
    initialiseToken();
  }

  initialiseToken() async {
    notifyListeners();
    fcmToken = await cache.getFCMToken();
  }

  // Future<String?> getFirebaseIdToken() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   // Get the FCM token
  //   String? fcmToken = await messaging.getToken();
  //   print("Firebase ID (FCM Token): $fcmToken");
  //
  //   return fcmToken;  // This is the Firebase ID you want to send to your server
  // }
  ///
  // Future<dynamic> login(mobile) async {
  //   loading = true;
  //   notifyListeners();
  //   // var userId = await cache.getUserId();
  //   await getDeviceInfo();
  //   final response = await _apiClient.dio.get(
  //     ApiUrls.login,
  //     queryParameters: {
  //       "Mobile": mobile,
  //       "DeviceID": deviceInfoModel?.deviceId ?? "",
  //       "Firebase": fcmToken,
  //     },
  //   );
  //   var data = json.decode(response.data);
  //   print(data);
  //   if (response.statusCode == 200) {
  //     if (data['Status'] == 'True') {
  //       await cache.setLoggedIn();
  //       userId = data['Data'][0]['ID'];
  //       await cache.setUserId(userId.toString());
  //     }
  //     // userModel = UserProfile.fromJson(response.data[0]);
  //     // print(userModel);
  //   }
  //   loading = false;
  //   notifyListeners();
  //   return data;
  // }


  Future<dynamic> login(mobile) async {
    loading = true;
    notifyListeners();

    try {
      await getDeviceInfo();
      final response = await _apiClient.dio.get(
        ApiUrls.login,
        queryParameters: {
          "Mobile": mobile,
          "DeviceID": deviceInfoModel?.deviceId ?? "",
          "Firebase": fcmToken,
        },
      );

      print("Raw Response: ${response.data}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data;
        final status = data['Status']?.toString().toLowerCase();

        // Sirf status 'true' hai ya nahi check karega
        if (status == 'true') {
          await cache.setLoggedIn();
          userId = data['Data'][0]['ID'];
          await cache.setUserId(userId.toString());
          // Exam availability check ko hata diya gaya hai
          return {"Status": "True", "Message": "Success"};
        } else {
          return {
            "Status": "False",
            "Message": data['Message'] ?? "Invalid response from server"
          };
        }
      } else if (response.statusCode == 200 && response.data is String) {
        // Agar response string hai to usse decode karega
        final data = json.decode(response.data);
        final status = data['Status']?.toString().toLowerCase();

        // Sirf status 'true' hai ya nahi check karega
        if (status == 'true') {
          await cache.setLoggedIn();
          userId = data['Data'][0]['ID'];
          await cache.setUserId(userId.toString());
          // Exam availability check ko hata diya gaya hai
          return {"Status": "True", "Message": "Success"};
        } else {
          return {
            "Status": "False",
            "Message": data['Message'] ?? "Invalid response from server"
          };
        }
      } else {
        return {"Status": "False", "Message": "Invalid response from server"};
      }
    } catch (e) {
      print("Login API Error: $e");
      return {"Status": "False", "Message": "Something went wrong"};
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  Future<int> getStateList() async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();

    final response = await _apiClient.dio.get(
      ApiUrls.state,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      stateList = await List.castFrom(
          data['Data'].map((e) => StateModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getClassList() async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();

    final response = await _apiClient.dio
        .get(ApiUrls.classes, queryParameters: {"GroupID": "0"});
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      groupList = await List.castFrom(
          data['Data'].map((e) => GroupModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getQrCode() async {
    loading = true;

    notifyListeners();
// var userId = await cache.getUserId();

    final response = await _apiClient.dio.get(
      ApiUrls.qrCode,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      qrCode = data['Data'][0]['QrImage'];
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<int> getQRInstruction() async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();

    final response = await _apiClient.dio.get(
      ApiUrls.qrInstruction,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      qrInstructionList = await List.castFrom(
          data['Data'].map((e) => QRInstructionModel.fromJson(e)).toList());
    }
    loading = false;
    notifyListeners();
    return response.statusCode ?? 500;
  }

  Future<dynamic> register({
    required String name,
    required String fName,
    required DateTime dob,
    required String mobile,
    required String category,
    required String state,
    required String address,
    required String pinCode,
    required String language,
    required String utrNo,
    required String group,
    required String gender,
    required String schoolName,
    required String subjectID,
    required String city,
    // required String image,
  }) async {
    loading = true;
    notifyListeners();
    // var userId = await cache.getUserId();
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    await getDeviceInfo();
    final response = await _apiClient.dio.post(
      ApiUrls.registerNew,
      options: Options(
        contentType:
        Headers.formUrlEncodedContentType, // x-www-form-urlencoded
      ),
      data: {
        "Group": group,
        "StudentName": base64.encode(utf8.encode(name)),
        "FatherName": base64.encode(utf8.encode(fName)),
        "DOB": DatesUtils.getFormattedDateOnly(dob),
        "MobileNo": mobile,
        "Category": category,
        "Citizen": gender,
        "CollegeName": base64.encode(utf8.encode(schoolName)),
        "StateID": state,
        "FieldID": '0',
        "PrantID": '0',
        "District":base64.encode(utf8.encode(city)) ,
        "Address": base64.encode(utf8.encode(address)),
        "Pincode": pinCode,
        "PrmotersName": base64.encode(utf8.encode(name)),
        "PrmotersMobileNo": '',
        "Class": subjectID,
        "Password": '',
        "Language": language,
        "DeviceID": deviceInfoModel?.deviceId ?? "",
        "Firebase": fcmToken,
        "UTRNo": utrNo,
        "City": city,
        "UTRImage":userImagePath,
      },
    );
    print(response.data);
    var data = json.decode(response.data);
    if (response.statusCode == 200) {
      // userModel = UserProfile.fromJson(response.data[0]);
      // print(userModel);

      print(data);
      if (kDebugMode) {
        print(data['Message']);
      }
    }
    loading = false;
    notifyListeners();
    return data;
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

  Future<String> updateProfile({
    required String name,
    required String fName,
    required DateTime dob,
    required String mobile,
    required String category,
    required String state,
    required String address,
    required String pinCode,
    required String language,
    required String group,
    required String gender,
    required String schoolName,
    required String subjectID,
    required String city,
  }) async {
    loading = true;
    notifyListeners();
    var userId = await cache.getUserId();
    var userData = {
      "StudentID": userId,
      "Group": group,
      "StudentName": base64.encode(utf8.encode(name)),
      "FatherName": base64.encode(utf8.encode(fName)),
      "DOB": DatesUtils.getFormattedDateOnly(dob),
      "MobileNo": mobile,
      "Category": category,
      "Citizen": gender,
      "CollegeName":  base64.encode(utf8.encode(schoolName)),
      "StateID": state,
      "FieldID": '0',
      "PrantID": '0',
      "District":  base64.encode(utf8.encode(city)),
      "Address": base64.encode(utf8.encode(address)),
      "Pincode": pinCode,
      "PrmotersName":  base64.encode(utf8.encode(name)),
      "PrmotersMobileNo": '',
      "Class": subjectID,
      "Password": '',
      "Language": language,
      "city": city,
    };
    print(userData);
    final response = await _apiClient.dio.get(
      ApiUrls.updateProfileNew,
      queryParameters: userData,
    );
    print(response.data);
    var data = json.decode(response.data);
    if (response.statusCode == 200) {
      // userModel = UserProfile.fromJson(response.data[0]);
      // print(userModel);
      getUserDetails();
      print(data);
      if (kDebugMode) {
        print(data['Message']);
      }
    }
    loading = false;
    notifyListeners();
    return data['Message'] ?? '';
  }

  getDeviceInfo() async {
    if (kIsWeb) {
      var info = await deviceInfo.webBrowserInfo;
      deviceInfoModel = DeviceInfoModel(
          userId: '',
          deviceId: info.productSub.toString(),
          ipv4: '',
          deviceToken: '',
          fcmId: 'utgthdhjgdxrfewsarfdgv',
          osType:
              'android release ${info.appVersion} sdk version ${info.appCodeName}',
          deviceType: 'web',
          mobileBrand: info.browserName.name);
      return;
    }
    fcmToken = await cache.getFCMToken();

    if (Platform.isAndroid) {
      var info = await deviceInfo.androidInfo;
      deviceInfoModel = DeviceInfoModel(
          userId: '',
          deviceId: info.id,
          ipv4: '',
          deviceToken: '',
          // fcmId: fcmToken,
          osType:
              'android release ${info.version.release} sdk version ${info.version.sdkInt}',
          deviceType: 'mobile',
          mobileBrand: info.brand);
    } else if (Platform.isIOS) {
      var info = await deviceInfo.iosInfo;
      deviceInfoModel = DeviceInfoModel(
        userId: '',
        deviceId: info.utsname.version,
        ipv4: '',
        deviceToken: '',
        fcmId: fcmToken,
        osType: '',
        deviceType: 'mobile',
        mobileBrand: info.systemName,
      );
    }

    if (deviceInfoModel == null) {
      getDeviceInfo();
      return;
    }
  }
  update(){

    notifyListeners();
  }
}
