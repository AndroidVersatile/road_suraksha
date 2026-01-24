class StateModel {
  String examDate;
  String stateId;
  String country;
  String stateName;
  String activeStatus;
  String isDel;
  String rts;
  String examDate1;

  StateModel({
    required this.examDate,
    required this.stateId,
    required this.country,
    required this.stateName,
    required this.activeStatus,
    required this.isDel,
    required this.rts,
    required this.examDate1,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
    examDate: json["ExamDate"],
    stateId: json["StateID"],
    country: json["Country"],
    stateName: json["StateName"],
    activeStatus: json["ActiveStatus"],
    isDel: json["isDel"],
    rts: json["RTS"],
    examDate1: json["ExamDate1"],
  );

  Map<String, dynamic> toJson() => {
    "ExamDate": examDate,
    "StateID": stateId,
    "Country": country,
    "StateName": stateName,
    "ActiveStatus":activeStatus,
    "isDel": isDel,
    "RTS": rts,
    "ExamDate1": examDate1,
  };
}


class GroupModel {
  String subjectId;
  String course;
  String courseName;
  String subjectIconImage;
  String subjectName;
  
  String subjectDescription;
  String activeStatus;
  String rts;
  String idAddress;
  String lmUserId;
  String lmUserName;
  String lmrts;
  String lmIpAddress;
  String lmRemarks;
  String isDel;
  String seqNo;

  GroupModel({
    required this.subjectId,
    required this.course,
    required this.courseName,
    required this.subjectIconImage,
    required this.subjectName,
    required this.subjectDescription,
    required this.activeStatus,
    required this.rts,
    required this.idAddress,
    required this.lmUserId,
    required this.lmUserName,
    required this.lmrts,
    required this.lmIpAddress,
    required this.lmRemarks,
    required this.isDel,
    required this.seqNo,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    subjectId: json["SubjectID"],
    course: json["Course"],
    courseName: json["CourseName"],
    subjectIconImage: json["SubjectIconImage"],
    subjectName: json["SubjectName"],
    subjectDescription: json["SubjectDescription"],
    activeStatus: json["ActiveStatus"],
    rts: json["RTS"],
    idAddress: json["IdAddress"],
    lmUserId: json["LMUserID"],
    lmUserName: json["LMUserName"],
    lmrts: json["LMRTS"],
    lmIpAddress: json["LMIpAddress"],
    lmRemarks: json["LMRemarks"],
    isDel: json["IsDel"],
    seqNo: json["SeqNo"],
  );

  Map<String, dynamic> toJson() => {
    "SubjectID": subjectId,
    "Course": course,
    "CourseName": courseName,
    "SubjectIconImage": subjectIconImage,
    "SubjectName": subjectName,
    "SubjectDescription": subjectDescription,
    "ActiveStatus": activeStatus,
    "RTS": rts,
    "IdAddress": idAddress,
    "LMUserID": lmUserId,
    "LMUserName": lmUserName,
    "LMRTS": lmrts,
    "LMIpAddress": lmIpAddress,
    "LMRemarks": lmRemarks,
    "IsDel": isDel,
    "SeqNo": seqNo,
  };
}
class QRInstructionModel {
  String instruction;

  QRInstructionModel({
    required this.instruction,
  });

  factory QRInstructionModel.fromJson(Map<String, dynamic> json) => QRInstructionModel(
    instruction: json["Instruction"],
  );

  Map<String, dynamic> toJson() => {
    "Instruction": instruction,
  };
}
class DistrictModel {
  final String districtId;
  final String districtName;

  DistrictModel({
    required this.districtId,
    required this.districtName,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    print("🔧 Parsing District JSON: $json");

    return DistrictModel(
      districtId: json['DistrictId']?.toString() ?? '',
      districtName: json['District']?.toString() ?? '',
    );
  }
}

class BlockModel {
  final String blockId;
  final String blockName;

  BlockModel({required this.blockId, required this.blockName});

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      blockId: json['BlockId'].toString(),
      blockName: json['BlockName'],
    );
  }
}
