class OnBoardingQuestionsModel {
  OnBoardingQuestionsModel({
    this.status,
    this.message,
    this.result,
  });

  OnBoardingQuestionsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
  }
  num? status;
  String? message;
  List<Result>? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Result {
  Result({
    this.question,
    this.key,
    this.answers,
  });

  Result.fromJson(dynamic json) {
    question = json['question'];
    key = json['key'];
    if (json['answers'] != null) {
      answers = [];
      json['answers'].forEach((v) {
        answers?.add(Answers.fromJson(v));
      });
    }
  }
  String? question;
  String? key;
  List<Answers>? answers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question'] = question;
    map['key'] = key;
    if (answers != null) {
      map['answers'] = answers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Answers {
  Answers({
    this.key,
    this.value,
  });

  Answers.fromJson(dynamic json) {
    key = json['key'].toString();
    value = json['value'].toString();
  }
  String? key;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['value'] = value;
    return map;
  }
}
