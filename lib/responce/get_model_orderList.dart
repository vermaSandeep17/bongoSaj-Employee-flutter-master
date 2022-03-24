import 'package:intl/intl.dart';

class Orders {
  final String orderId;
  final String name;
  final String state;
  final String email;
  final String phone;
  final String date;
  final String orderStatus;
  final String confirmationStatus;
  final String totalCall;
  final String call1EmpName;
  final String call1Note;
  final String call1DateTime;
  final String call2EmpName;
  final String call2Note;
  final String call2DateTime;
  final String call3EmpName;
  final String call3Note;
  final String call3DateTime;

  Orders(
    this.name,
    this.orderId,
    this.state,
    this.phone,
    this.date,
    this.email,
    this.orderStatus,
    this.confirmationStatus,
    this.totalCall,
    this.call1EmpName,
    this.call1Note,
    this.call1DateTime,
    this.call2EmpName,
    this.call2Note,
    this.call2DateTime,
    this.call3EmpName,
    this.call3Note,
    this.call3DateTime,
  );

  Orders.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        orderId = json['order_id'] as String,
        state = json['state'] as String,
        phone = json['phone'] as String,
        date = json['date'] as String,
        email = json['email'] as String,
        orderStatus = json['order_status'] as String,
        confirmationStatus = json['confirmation_status'] as String,
        totalCall = json['totalcall'] as String,
        call1EmpName = json['call1_empname'] as String,
        call1Note = json['call1note'] as String,
        call1DateTime = json['call1datetime'] as String,
        call2EmpName = json['call2_empname'] as String,
        call2Note = json['call2note'] as String,
        call2DateTime = json['call2datetime'] as String,
        call3EmpName = json['call3_empname'] as String,
        call3Note = json['call3note'] as String,
        call3DateTime = json['call3datetime'] as String;

  Map<String, Object> toJson() => <String, Object>{
        'order_id': orderId,
        'name': name,
        'state': state,
        'phone': phone,
        'date': date,
        'email': email,
        'order_status': orderStatus,
        'confirmation_status': confirmationStatus,
        'totalcall': totalCall,
        'call1_empname': call1EmpName,
        'call1note': call1Note,
        'call1datetime': call1DateTime,
        'call2_empname': call2EmpName,
        'call2note': call2Note,
        'call2datetime': call2DateTime,
        'call3_empname': call3EmpName,
        'call3note': call3Note,
        'call3datetime': call3DateTime,
      };
}
