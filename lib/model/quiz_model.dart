class QuizModel {
  String trace;
  String refNo;
  String exam;
  String subject;
  String questionId;
  String question;
  String optionA;
  String optionB;
  String optionC;
  String optionD;
  String optionE;
  String optionF;
  String questionAnswer;
  String questionAttemptedAnswerDemo;
  String questionDisplayTime;
  String questionMarks;
  String studentId;
  String qImage;
  String aImage;
  String bImage;
  String cImage;
  String dImage;
  String eImage;
  String fImage;
  String isImage;

  QuizModel({
    required this.trace,
    required this.refNo,
    required this.exam,
    required this.subject,
    required this.questionId,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.optionE,
    required this.optionF,
    required this.questionAnswer,
    required this.questionAttemptedAnswerDemo,
    required this.questionDisplayTime,
    required this.questionMarks,
    required this.studentId,
    required this.qImage,
    required this.aImage,
    required this.bImage,
    required this.cImage,
    required this.dImage,
    required this.eImage,
    required this.fImage,
    required this.isImage,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        trace: json["Trace"],
        refNo: json["RefNo"],
        exam: json["Exam"],
        subject: json["Subject"],
        questionId: json["QuestionID"],
        question: json["Question"],
        optionA: json["OptionA"],
        optionB: json["OptionB"],
        optionC: json["OptionC"],
        optionD: json["OptionD"],
        optionE: json["OptionE"],
        optionF: json["OptionF"],
        questionAnswer: json["QuestionAnswer"],
        questionAttemptedAnswerDemo: json["QuestionAttemptedAnswerDemo"] ?? "",
        questionDisplayTime: json["QuestionDisplayTime"],
        questionMarks: json["QuestionMarks"],
        studentId: json["StudentID"],
        qImage: json["QImage"],
        aImage: json["AImage"],
        bImage: json["BImage"],
        cImage: json["CImage"],
        dImage: json["DImage"],
        eImage: json["EImage"],
        fImage: json["FImage"],
        isImage: json["isImage"],
      );

  Map<String, dynamic> toJson() => {
        "Trace": trace,
        "RefNo": refNo,
        "Exam": exam,
        "Subject": subject,
        "QuestionID": questionId,
        "Question": question,
        "OptionA": optionA,
        "OptionB": optionB,
        "OptionC": optionC,
        "OptionD": optionD,
        "OptionE": optionE,
        "OptionF": optionF,
        "QuestionAnswer": questionAnswer,
        "QuestionAttemptedAnswerDemo": questionAttemptedAnswerDemo,
        "QuestionDisplayTime": questionDisplayTime,
        "QuestionMarks": questionMarks,
        "StudentID": studentId,
        "QImage": qImage,
        "AImage": aImage,
        "BImage": bImage,
        "CImage": cImage,
        "DImage": dImage,
        "EImage": eImage,
        "FImage": fImage,
        "isImage": isImage,
      };

  // Method to convert options to a list
  List<Map<String, Object>> getOptions() {
    List<Map<String, Object>> options = [];
    if (optionA.isNotEmpty) options.add({'text': optionA, 'index': 'A'});
    if (optionB.isNotEmpty) options.add({'text': optionB, 'index': 'B'});
    if (optionC.isNotEmpty) options.add({'text': optionC, 'index': 'C'});
    if (optionD.isNotEmpty) options.add({'text': optionD, 'index': 'D'});
    if (optionE.isNotEmpty) options.add({'text': optionE, 'index': 'E'});
    if (optionF.isNotEmpty) options.add({'text': optionF, 'index': 'F'});
    return options;
  }
}

class LoadLiveExamModel {
  String status;
  String msg;
  String examId;
  String isExamFree;
  String course;
  String courseName;
  String subject;
  String subjectName;
  String examIconImage;
  String examName;
  String examType;
  String examDescription;
  String questionInExam;
  String rts;
  String activeStatus;
  String ipAddress;
  String lmUserId;
  String lmUserName;
  String lmrts;
  String lmIpAddress;
  String lmRemarks;
  String isDel;
  String isActivated;
  String examDateTime;
  String examTypeId;
  String attemptExam;
  String mesageForExam;
  String currentDate;
  String examTime;
  String fieldId;
  String stateId;

  LoadLiveExamModel({
    required this.status,
    required this.msg,
    required this.examId,
    required this.isExamFree,
    required this.course,
    required this.courseName,
    required this.subject,
    required this.subjectName,
    required this.examIconImage,
    required this.examName,
    required this.examType,
    required this.examDescription,
    required this.questionInExam,
    required this.rts,
    required this.activeStatus,
    required this.ipAddress,
    required this.lmUserId,
    required this.lmUserName,
    required this.lmrts,
    required this.lmIpAddress,
    required this.lmRemarks,
    required this.isDel,
    required this.isActivated,
    required this.examDateTime,
    required this.examTypeId,
    required this.attemptExam,
    required this.mesageForExam,
    required this.currentDate,
    required this.examTime,
    required this.fieldId,
    required this.stateId,
  });

  factory LoadLiveExamModel.fromJson(Map<String, dynamic> json) =>
      LoadLiveExamModel(
        status: json["status"],
        msg: json["msg"],
        examId: json["ExamID"],
        isExamFree: json["isExamFree"],
        course: json["Course"],
        courseName: json["CourseName"],
        subject: json["Subject"],
        subjectName: json["SubjectName"],
        examIconImage: json["ExamIconImage"],
        examName: json["ExamName"],
        examType: json["ExamType"],
        examDescription: json["ExamDescription"],
        questionInExam: json["QuestionInExam"],
        rts: json["RTS"],
        activeStatus: json["ActiveStatus"],
        ipAddress: json["IpAddress"],
        lmUserId: json["LMUserID"],
        lmUserName: json["LMUserName"],
        lmrts: json["LMRTS"],
        lmIpAddress: json["LMIpAddress"],
        lmRemarks: json["LMRemarks"],
        isDel: json["isDel"],
        isActivated: json["isActivated"],
        examDateTime: json["ExamDateTime"],
        examTypeId: json["ExamTypeID"],
        attemptExam: json["AttemptExam"],
        mesageForExam: json["MesageForExam"],
        currentDate: json["CurrentDate"],
        examTime: json["ExamTime"],
        fieldId: json["FieldID"] ?? "",
        stateId: json["StateID"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "ExamID": examId,
        "isExamFree": isExamFree,
        "Course": course,
        "CourseName": courseName,
        "Subject": subject,
        "SubjectName": subjectName,
        "ExamIconImage": examIconImage,
        "ExamName": examName,
        "ExamType": examType,
        "ExamDescription": examDescription,
        "QuestionInExam": questionInExam,
        "RTS": rts,
        "ActiveStatus": activeStatus,
        "IpAddress": ipAddress,
        "LMUserID": lmUserId,
        "LMUserName": lmUserName,
        "LMRTS": lmrts,
        "LMIpAddress": lmIpAddress,
        "LMRemarks": lmRemarks,
        "isDel": isDel,
        "isActivated": isActivated,
        "ExamDateTime": examDateTime,
        "ExamTypeID": examTypeId,
        "AttemptExam": attemptExam,
        "MesageForExam": mesageForExam,
        "CurrentDate": currentDate,
        "ExamTime": examTime,
        "FieldID": fieldId,
        "StateID": stateId,
      };
}

class CertificateModel {
  String rts;
  String empExamId;
  String empId;
  String examId;
  String isAttemped;
  String maximumMarks;
  String minimumMarks;
  String marksOccupied;
  String persantage;
  String divGrade;
  String positionOccupied;
  String rts1;
  String attempRts;
  String resultRts;
  String activeStatus;
  String isDel;
  String autoRemarks;
  String course;
  String subject;
  String examTypeId;
  String stateId;
  String fieldId;
  String prantId;
  String studentName;
  String city;
  String status;
  String grade;
  String examName;

  CertificateModel({
    required this.rts,
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
    required this.rts1,
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
    required this.studentName,
    required this.city,
    required this.status,
    required this.grade,
    required this.examName,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      CertificateModel(
        rts: json["RTS"],
        empExamId: json["EmpExamID"],
        empId: json["EmpID"],
        examId: json["ExamID"],
        isAttemped: json["IsAttemped"],
        maximumMarks: json["MaximumMarks"],
        minimumMarks: json["MinimumMarks"],
        marksOccupied: json["MarksOccupied"],
        persantage: json["Persantage"],
        divGrade: json["DivGrade"],
        positionOccupied: json["PositionOccupied"],
        rts1: json["RTS1"],
        attempRts: json["AttempRTS"],
        resultRts: json["ResultRTS"],
        activeStatus: json["ActiveStatus"],
        isDel: json["isDel"],
        autoRemarks: json["AutoRemarks"],
        course: json["Course"],
        subject: json["Subject"],
        examTypeId: json["ExamTypeID"],
        stateId: json["StateId"],
        fieldId: json["FieldID"],
        prantId: json["PrantID"],
        studentName: json["StudentName"],
        city: json["City"],
        status: json["Status"],
        grade: json["Grade"],
        examName: json["ExamName"],
      );

  Map<String, dynamic> toJson() => {
        "RTS": rts,
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
        "RTS1": rts1,
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
        "StudentName": studentName,
        "City": city,
        "Status": status,
        "Grade": grade,
        "ExamName": examName,
      };
}

class DemoCertificateModel {
  String rts;
  String empExamId;
  String empId;
  String examId;
  String isAttemped;
  String maximumMarks;
  String minimumMarks;
  String marksOccupied;
  String persantage;
  String divGrade;
  String positionOccupied;
  String rts1;
  String attempRts;
  String resultRts;
  String autoRemarks;
  String course;
  String subject;
  String examTypeId;
  String stateId;
  String isdel;
  String activeStatus;
  String studentName;
  String city;
  String status;
  String grade;
  String examName;

  DemoCertificateModel({
    required this.rts,
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
    required this.rts1,
    required this.attempRts,
    required this.resultRts,
    required this.autoRemarks,
    required this.course,
    required this.subject,
    required this.examTypeId,
    required this.stateId,
    required this.isdel,
    required this.activeStatus,
    required this.studentName,
    required this.city,
    required this.status,
    required this.grade,
    required this.examName,
  });

  factory DemoCertificateModel.fromJson(Map<String, dynamic> json) =>
      DemoCertificateModel(
        rts: json["RTS"],
        empExamId: json["EmpExamID"],
        empId: json["EmpID"],
        examId: json["ExamID"],
        isAttemped: json["IsAttemped"],
        maximumMarks: json["MaximumMarks"],
        minimumMarks: json["MinimumMarks"],
        marksOccupied: json["MarksOccupied"],
        persantage: json["Persantage"],
        divGrade: json["DivGrade"],
        positionOccupied: json["PositionOccupied"],
        rts1: json["RTS1"],
        attempRts: json["AttempRTS"],
        resultRts: json["ResultRTS"],
        autoRemarks: json["AutoRemarks"],
        course: json["Course"],
        subject: json["Subject"],
        examTypeId: json["ExamTypeID"],
        stateId: json["StateId"],
        isdel: json["isdel"],
        activeStatus: json["ActiveStatus"],
        studentName: json["StudentName"],
        city: json["City"],
        status: json["Status"],
        grade: json["Grade"],
        examName: json["ExamName"],
      );

  Map<String, dynamic> toJson() => {
        "RTS": rts,
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
        "RTS1": rts1,
        "AttempRTS": attempRts,
        "ResultRTS": resultRts,
        "AutoRemarks": autoRemarks,
        "Course": course,
        "Subject": subject,
        "ExamTypeID": examTypeId,
        "StateId": stateId,
        "isdel": isdel,
        "ActiveStatus": activeStatus,
        "StudentName": studentName,
        "City": city,
        "Status": status,
        "Grade": grade,
        "ExamName": examName,
      };
}
