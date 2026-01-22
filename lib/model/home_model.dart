class SliderModel {
  String autoId;
  String imageUrl;
  String activeStatus;
  String isDel;
  String rts;

  SliderModel({
     this.autoId='',
     this.imageUrl='',
     this.activeStatus='',
     this.isDel='',
     this.rts='',
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
    autoId: json["AutoID"],
    imageUrl: json["ImageUrl"],
    activeStatus:json["ActiveStatus"],
    isDel: json["isDel"],
    rts: json["RTS"],
  );

  Map<String, dynamic> toJson() => {
    "AutoID": autoId,
    "ImageUrl": imageUrl,
    "ActiveStatus": activeStatus,
    "isDel": isDel,
    "RTS": rts,
  };
}


class AboutGauMata {
  int aid;
  String? url;
  String activeStatus;
  String isDel;
  String rts;
  String name;
  String? fileURl;

  AboutGauMata({
    required this.aid,
    this.url,
    required this.activeStatus,
    required this.isDel,
    required this.rts,
    required this.name,
    this.fileURl,
  });

  factory AboutGauMata.fromJson(Map<String, dynamic> json) => AboutGauMata(
    aid: json["AID"],
    url: json["URL"],
    activeStatus: json["ActiveStatus"]!,
    isDel: json["isDel"]!,
    rts: json["RTS"],
    name: json["Name"],
    fileURl: json["FileURl"],
  );

  Map<String, dynamic> toJson() => {
    "AID": aid,
    "URL": url,
    "ActiveStatus":activeStatus,
    "isDel": isDel,
    "RTS": rts,
    "Name": name,
    "FileURl": fileURl,
  };
}

class LatestNewsModel {
  dynamic ruleId;
  String ruleText;
  String activeStatus;
  String isdel;
  String rts;


  LatestNewsModel({
    required this.ruleId,
    required this.ruleText,
    required this.activeStatus,
    required this.isdel,
    required this.rts,

  });

  factory LatestNewsModel.fromJson(Map<String, dynamic> json) => LatestNewsModel(
    ruleId: json["RuleID"].toString(),
    ruleText: json["RuleText"]??"",
    activeStatus: json["ActiveStatus"]??"",
    isdel: json["isdel"]??"",
    rts: json["RTS"]??"",

  );

  Map<String, dynamic> toJson() => {
    "RuleID": ruleId,
    "RuleText": ruleText,
    "ActiveStatus": activeStatus,
    "isdel": isdel,
    "RTS": rts,

  };
}


class OtherNewsModel {
  String categoryId;
  String categoryName;
  String type;
  String fileURl;
  String audioURl;
  String videoFile;

  OtherNewsModel({
    required this.categoryId,
    required this.categoryName,
    required this.type,
    required this.fileURl,
    required this.audioURl,
    required this.videoFile,
  });

  factory OtherNewsModel.fromJson(Map<String, dynamic> json) => OtherNewsModel(
    categoryId: json["CategoryID"],
    categoryName: json["CategoryName"],
    type: json["Type"],
    fileURl: json["FileURl"],
    audioURl: json["AudioURl"],
    videoFile: json["VideoFile"],
  );

  Map<String, dynamic> toJson() => {
    "CategoryID": categoryId,
    "CategoryName": categoryName,
    "Type": type,
    "FileURl": fileURl,
    "AudioURl": audioURl,
    "VideoFile": videoFile,
  };
}


class UserModel {
  String dob;
  String subjectName;
  String courseName;
  String id;
  String studentName;
  String mobile;
  String email;
  String passw;
  String memberType;
  String activeStatus;
  String isDel;
  String rts;
  String deviceId;
  String firebase;
  String ipAddress;
  String lmUserId;
  String lmUserName;
  String lmRemarks;
  String course;
  String subject;
  String lastLogin;
  String schoolName;
  String fatherName;
  String fatherBusiness;
  String address;
  String post;
  String tehsil;
  String district;
  String state;
  String pincode;
  String status;
  String whatsappNo;
  String dob1;
  String city;
  String category;
  String citizen;
  String collegeName;
  String fieldId;
  String prantId;
  String prmotersName;
  String prmotersMobileNo;
  String nReg;
  String language;
  String utrNo;

  UserModel({
    required this.dob,
    required this.subjectName,
    required this.courseName,
    required this.id,
    required this.studentName,
    required this.mobile,
    required this.email,
    required this.passw,
    required this.memberType,
    required this.activeStatus,
    required this.isDel,
    required this.rts,
    required this.deviceId,
    required this.firebase,
    required this.ipAddress,
    required this.lmUserId,
    required this.lmUserName,
    required this.lmRemarks,
    required this.course,
    required this.subject,
    required this.lastLogin,
    required this.schoolName,
    required this.fatherName,
    required this.fatherBusiness,
    required this.address,
    required this.post,
    required this.tehsil,
    required this.district,
    required this.state,
    required this.pincode,
    required this.status,
    required this.whatsappNo,
    required this.dob1,
    required this.city,
    required this.category,
    required this.citizen,
    required this.collegeName,
    required this.fieldId,
    required this.prantId,
    required this.prmotersName,
    required this.prmotersMobileNo,
    required this.nReg,
    required this.language,
    required this.utrNo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    dob: json["DOB"],
    subjectName: json["SubjectName"],
    courseName: json["CourseName"],
    id: json["ID"],
    studentName: json["StudentName"],
    mobile: json["Mobile"],
    email: json["Email"],
    passw: json["Passw"],
    memberType: json["MemberType"],
    activeStatus: json["ActiveStatus"],
    isDel: json["isDel"],
    rts: json["RTS"],
    deviceId: json["DeviceID"],
    firebase: json["Firebase"],
    ipAddress: json["IpAddress"],
    lmUserId: json["LMUserID"],
    lmUserName: json["LMUserName"],
    lmRemarks: json["LMRemarks"],
    course: json["Course"],
    subject: json["Subject"],
    lastLogin: json["LastLogin"],
    schoolName: json["SchoolName"],
    fatherName: json["FatherName"],
    fatherBusiness: json["FatherBusiness"],
    address: json["Address"],
    post: json["Post"],
    tehsil: json["Tehsil"],
    district: json["District"],
    state: json["State"],
    pincode: json["Pincode"],
    status: json["Status"],
    whatsappNo: json["WhatsappNo"],
    dob1: json["DOB1"],
    city: json["City"],
    category: json["Category"],
    citizen: json["Citizen"],
    collegeName: json["CollegeName"],
    fieldId: json["FieldID"],
    prantId: json["PrantID"],
    prmotersName: json["PrmotersName"],
    prmotersMobileNo: json["PrmotersMobileNo"],
    nReg: json["NReg"],
    language: json["Language"],
    utrNo: json["UTRNo"],
  );

  Map<String, dynamic> toJson() => {
    "DOB": dob,
    "SubjectName": subjectName,
    "CourseName": courseName,
    "ID": id,
    "StudentName": studentName,
    "Mobile": mobile,
    "Email": email,
    "Passw": passw,
    "MemberType": memberType,
    "ActiveStatus": activeStatus,
    "isDel": isDel,
    "RTS": rts,
    "DeviceID": deviceId,
    "Firebase": firebase,
    "IpAddress": ipAddress,
    "LMUserID": lmUserId,
    "LMUserName": lmUserName,
    "LMRemarks": lmRemarks,
    "Course": course,
    "Subject": subject,
    "LastLogin": lastLogin,
    "SchoolName": schoolName,
    "FatherName": fatherName,
    "FatherBusiness": fatherBusiness,
    "Address": address,
    "Post": post,
    "Tehsil": tehsil,
    "District": district,
    "State": state,
    "Pincode": pincode,
    "Status": status,
    "WhatsappNo": whatsappNo,
    "DOB1": dob1,
    "City": city,
    "Category": category,
    "Citizen": citizen,
    "CollegeName": collegeName,
    "FieldID": fieldId,
    "PrantID": prantId,
    "PrmotersName": prmotersName,
    "PrmotersMobileNo": prmotersMobileNo,
    "NReg": nReg,
    "Language": language,
    "UTRNo": utrNo,
  };
}
