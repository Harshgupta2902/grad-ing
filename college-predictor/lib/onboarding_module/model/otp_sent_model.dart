class OtpSentModel {
  OtpSentModel({
    this.message,
    this.status,
    this.result,
  });

  OtpSentModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  String? message;
  num? status;
  Result? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    if (result != null) {
      map['result'] = result?.toJson();
    }
    return map;
  }
}

class Result {
  Result({
    this.otp,
    this.user,
  });

  Result.fromJson(dynamic json) {
    otp = json['otp'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? otp;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp'] = otp;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}

class User {
  User({
    this.name,
    this.lastName,
    this.country,
    this.countryCode,
    this.phone,
  });

  User.fromJson(dynamic json) {
    name = json['name'];
    lastName = json['last_name'];
    country = json['country'];
    countryCode = json['country_code'];
    phone = json['phone'];
  }

  String? name;
  String? lastName;
  String? country;
  String? countryCode;
  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['last_name'] = lastName;
    map['country'] = country;
    map['country_code'] = countryCode;
    map['phone'] = phone;
    return map;
  }
}
