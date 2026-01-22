import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../constants/api_urls.dart';
import '../model/api_response.dart';

class APIService {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      validateStatus: (status) => true,
      followRedirects: true,
      maxRedirects: 3,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 50000),
    ),
  );

  static final APIService _apiService = APIService._internal();

  Map<String, String> header = {
    "Content-type": "application/json",
  };
  final Connectivity _connectivity = Connectivity();
  bool isConnected = true;
  BuildContext? context;
  final String username = 'test_api'; // Replace with your actual username
  final String password = 'test#\$&api'; // Replace with your actual password
  ApiResponse noConnectionResponse = ApiResponse(
    message: "Not Connected To Internet",
    statusCode: 500,
  );

  factory APIService.ApiClient() {
    return _apiService;
  }

  APIService._internal() {
    init();
    setToken();
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        validateStatus: (status) => true,
        followRedirects: true,
        maxRedirects: 3,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 50000),
      ),
    );
  }

  void setToken() {
    header = {
      "content-type": "application/json",
      "accept": "*/*",
      "authorization":
          'Basic ${base64Encode(utf8.encode('$username:$password'))}'
    };
    dio.options.headers = header;
  }

  getToken() => header["authorization"]?.replaceAll("Bearer ", "");

  Future<void> init() async {
    isConnected =
        (await _connectivity.checkConnectivity()) != ConnectivityResult.none;
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        isConnected = false;
        showSnackBar(msg: 'Not Connected to internet');
      } else {
        isConnected = true;
      }
    });
  }

  Future<ApiResponse> postRequestAPI({
    required String path,
    required dynamic data,
    dynamic params,
    bool isShowMessage = false,
  }) async {
    final ApiResponse apiResponse = noConnectionResponse;

    if (!isConnected) {
      showSnackBar(msg: 'Not Connected to internet');
      return noConnectionResponse;
    }
    // final body = jsonEncode(data);
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: params ?? {},
        options: Options(headers: header),
      );

      final res = checkingResponse(response, isShowMessage: true);
      showLog(
        "POST REQUEST $path \n\n HEADER $header \n\nSUCCESS RESPONSE ${response.data.toString()} ",
      );

      return res;
    } on DioException catch (e) {
      showLog(
        "POST REQUEST $path \n\n HEADER $header \n\nERROR RESPONSE ${e.toString()} ",
      );
      return apiResponse;
    }
  }

  Future<ApiResponse> getRequestAPI({
    required String path,
    Map<String, dynamic>? params,
    bool isShowMessage = false,
  }) async {
    final ApiResponse apiResponse = noConnectionResponse;
    if (!isConnected) {
      showSnackBar(msg: 'Not Connected to internet');
      return apiResponse;
    }
    try {
      final response = await dio.get(
        path,
        queryParameters: params,
        options: Options(headers: header),
      );
      print(response);
      final res = checkingResponse(response, isShowMessage: isShowMessage);
      showLog(
        "GET REQUEST $path \n\n HEADER $header \n\nSUCCESS RESPONSE ${response.data.toString()} ",
      );
      return res;
    } on DioException catch (e) {
      showLog(
        "GET REQUEST $path \n\n HEADER $header \n\nERROR RESPONSE ${e.toString()} ",
      );
      return apiResponse;
    }
  }

  ApiResponse checkingResponse(
    Response response, {
    bool isShowMessage = true,
  }) {
    ApiResponse apiResponse = noConnectionResponse;
    try {
      apiResponse.data = response.data;
      apiResponse.statusCode = response.statusCode!;
      apiResponse.message = response.statusMessage!;

      if (isShowMessage) {
        if (response.statusCode == 200) {
          showLog(
            "HEADER $header \n\nSuccess RESPONSE ${apiResponse.message ?? ""} ",
          );
          showSnackBar(msg: apiResponse.message!);
        } else {
          showLog(
            " \n\n HEADER $header \n\nERROR RESPONSE ${apiResponse.message ?? ""} ",
          );
          showSnackBar(msg: apiResponse.message!);
        }
      }
      return apiResponse;
    } catch (e) {
      return apiResponse;
    }
  }

  void showLog(String message) {
    if (kDebugMode) {
      print(message);
      print(
        "RESPONSE MESSAGE_____!!!!!!!!!__<<<<<<<<<____<<<<<<<<<<<<<<<<<<<<<",
      );
    }
  }

  showSnackBar({String msg = ''}) {
    Fluttertoast.showToast(msg: msg);
  }

  showNoInternetDialog(
      {required BuildContext context, required ApiResponse response}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(response.message.toString()),
          content: const Text('Please check your Network Connectivity'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('OK'))
          ]),
    );
  }
}




class PaymentService {
  static const platform = MethodChannel('com.example.dayjoyapp/phonepe');

  Future<void> startPayment(String merchantId, String secretKey, String transactionId, String amount) async {
    try {
      final result = await platform.invokeMethod('startPayment', {
        'merchantId': merchantId,
        'secretKey': secretKey,
        'transactionId': transactionId,
        'amount': amount,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to start payment: ${e.message}");
    }
  }
}

