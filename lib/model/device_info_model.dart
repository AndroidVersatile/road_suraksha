
class DeviceInfoModel {
  DeviceInfoModel({
    this.userId = '',
    this.deviceId = '',
    this.ipv4 = '',
    this.deviceToken = '',
    this.fcmId = '',
    this.osType = '',
    this.deviceType = '',
    this.mobileBrand = '',

    /// ..................................web model .............................
    this.browserName = '',
    this.appCodeName = '',
    this.appName = '',
    this.appVersion = '',
    this.deviceMemory = 0,
    this.language = '',
    this.languages = const [],
    this.platform = '',
    this.product = '',
    this.productSub = '',
    this.userAgent = '',
    this.vendor = '',
    this.vendorSub = '',
    this.hardwareConcurrency = 0,
    this.maxTouchPoints = 0,
  });

  String userId;
  String deviceId;
  String ipv4;
  String deviceToken;
  String fcmId;
  String osType;
  String deviceType;
  String mobileBrand;

  /// ..................................web model .............................
  String browserName;
  String appCodeName;
  String appName;
  String appVersion;
  int deviceMemory;
  String language;
  List<dynamic> languages;
  String platform;
  String product;
  String productSub;
  String userAgent;
  String vendor;
  String vendorSub;
  int hardwareConcurrency;
  int maxTouchPoints;

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'device_id': deviceId,
    'ipv4': ipv4,
    'device_token': deviceToken,
    'fcm_id': fcmId,
    'os_type': osType,
    'device_type': deviceType,
    'mobile_brand': mobileBrand,
  };


}