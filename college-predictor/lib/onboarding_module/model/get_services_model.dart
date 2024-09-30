class GetServicesModel {
  GetServicesModel({
      this.status, 
      this.message, 
      this.result,});

  GetServicesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    result = json['result'] != null ? json['result'].cast<String>() : [];
  }
  num? status;
  String? message;
  List<String>? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['result'] = result;
    return map;
  }

}