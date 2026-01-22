import 'dart:convert';

class ApiResponse {
  String? message;
  // bool status;
  int statusCode;
  dynamic data;

  ApiResponse({
    this.message = '',
    // this.status = false,
    this.statusCode = 404,
    this.data,
  });

  factory ApiResponse.fromJson(String? jsonString) {
    if (jsonString == null) {
      return ApiResponse(
        message: 'Oops! Sorry We have Problem',
        // status: false,
        statusCode: 800,
        data: null,
      );
    }
    var data = jsonDecode(jsonString);
    try {
      return ApiResponse(
        message: data['message'],
        // status: data['success'] ?? true,
        data: data['data'],
        statusCode: data['statuscode'] ?? 400,
      );
    } catch (e) {
      return ApiResponse(
        message: e.toString(),
        // status: false,
        statusCode: 800,
        data: null,
      );
    }
  }

  @override
  String toString() {
    return {
      'message': message,
      // 'success': status,
      'data': data.toString(),
      'statuscode': statusCode,
    }.toString();
  }
}