class ExamDetail {
  int total;
  int seen;
  int unSeen;
  int unAnswered;
  int rightAnswered;
  int wrong;
  int totalNumber;
  double persantage;

  ExamDetail({
    required this.total,
    required this.seen,
    required this.unSeen,
    required this.unAnswered,
    required this.rightAnswered,
    required this.wrong,
    required this.totalNumber,
    required this.persantage,
  });

  factory ExamDetail.fromJson(Map<String, dynamic> json) => ExamDetail(
    total: json["Total"],
    seen: json["Seen"],
    unSeen: json["UnSeen"],
    unAnswered: json["UnAnswered"],
    rightAnswered: json["RightAnswered"],
    wrong: json["Wrong"],
    totalNumber: json["TotalNumber"],
    persantage: json["Persantage"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "Seen": seen,
    "UnSeen": unSeen,
    "UnAnswered": unAnswered,
    "RightAnswered": rightAnswered,
    "Wrong": wrong,
    "TotalNumber": totalNumber,
    "Persantage": persantage,
  };
}

class Main {
  int empExamId;
  int empId;
  int examId;
  String isAttemped;
  double maximumMarks;
  double minimumMarks;
  double marksOccupied;
  double persantage;
  String divGrade;
  int positionOccupied;
  String rts;
  dynamic attempRts;
  String resultRts;
  String activeStatus;
  String isDel;
  String autoRemarks;
  String course;
  String subject;
  int examTypeId;
  int stateId;
  int fieldId;
  int prantId;

  Main({
    required this.empExamId,
    required this.empId,
    required this.examId,
    required this.isAttemped,
    required this.maximumMarks,
    required this.minimumMarks,
    required this.marksOccupied,
    required this.persantage,
    required this.divGrade,
    required this.positionOccupied,
    required this.rts,
    required this.attempRts,
    required this.resultRts,
    required this.activeStatus,
    required this.isDel,
    required this.autoRemarks,
    required this.course,
    required this.subject,
    required this.examTypeId,
    required this.stateId,
    required this.fieldId,
    required this.prantId,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
    empExamId: json["EmpExamID"],
    empId: json["EmpID"],
    examId: json["ExamID"],
    isAttemped: json["IsAttemped"],
    maximumMarks: json["MaximumMarks"],
    minimumMarks: json["MinimumMarks"],
    marksOccupied: json["MarksOccupied"],
    persantage: json["Persantage"]?.toDouble(),
    divGrade: json["DivGrade"],
    positionOccupied: json["PositionOccupied"],
    rts: json["RTS"],
    attempRts: json["AttempRTS"],
    resultRts: json["ResultRTS"],
    activeStatus: json["ActiveStatus"],
    isDel: json["isDel"]??"",
    autoRemarks: json["AutoRemarks"],
    course: json["Course"],
    subject: json["Subject"],
    examTypeId: json["ExamTypeID"],
    stateId: json["StateId"],
    fieldId: json["FieldID"]??0,
    prantId: json["PrantID"]??0,
  );

  Map<String, dynamic> toJson() => {
    "EmpExamID": empExamId,
    "EmpID": empId,
    "ExamID": examId,
    "IsAttemped": isAttemped,
    "MaximumMarks": maximumMarks,
    "MinimumMarks": minimumMarks,
    "MarksOccupied": marksOccupied,
    "Persantage": persantage,
    "DivGrade": divGrade,
    "PositionOccupied": positionOccupied,
    "RTS": rts,
    "AttempRTS": attempRts,
    "ResultRTS": resultRts,
    "ActiveStatus": activeStatus,
    "isDel": isDel,
    "AutoRemarks": autoRemarks,
    "Course": course,
    "Subject": subject,
    "ExamTypeID": examTypeId,
    "StateId": stateId,
    "FieldID": fieldId,
    "PrantID": prantId,
  };
}