class GetModelUserlogin {
  GetModelUserlogin({
    required this.status,
    required this.msg,
    required this.information,
  });
  late final int status;
  late final String msg;
  late final Information information;

  GetModelUserlogin.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    information = Information.fromJson(json['Information']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['Information'] = information.toJson();
    return _data;
  }
}

class Information {
  Information({
    required this.userId,
    required this.fullname,
    required this.phone,
  });
  late final String userId;
  late final String fullname;
  late final String phone;

  Information.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullname = json['fullname'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['fullname'] = fullname;
    _data['phone'] = phone;
    return _data;
  }
}
