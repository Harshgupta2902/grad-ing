class MobileVerificationModel {
  MobileVerificationModel({
    this.message,
    this.status,
    this.result,
  });

  MobileVerificationModel.fromJson(dynamic json) {
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
    this.user,
    this.token,
  });

  Result.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }
  User? user;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['token'] = token;
    return map;
  }
}

class User {
  User({
    this.name,
    this.lastName,
    this.countryCode,
    this.phone,
    this.email,
    this.imageUrl,
  });

  User.fromJson(dynamic json) {
    name = json['name'];
    lastName = json['last_name'];
    countryCode = json['country_code'];
    phone = json['phone'];
    email = json['email'];
    imageUrl = json['image_url'];
  }
  String? name;
  String? lastName;
  String? countryCode;
  String? phone;
  String? email;
  String? imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['last_name'] = lastName;
    map['country_code'] = countryCode;
    map['phone'] = phone;
    map['email'] = email;
    map['image_url'] = imageUrl;
    return map;
  }
}
