class OrderItem {
  final String orderId;
  final String state;
  final String totalCall;
  final String name;
  final String email;
  final String phone;
  final String date;
  final String orderStatus;
  final String confirmationStatus;
  final String call1EmpName;
  final String call1Note;
  final String call1DateTime;
  final String call2EmpName;
  final String call2Note;
  final String call2DateTime;
  final String call3EmpName;
  final String call3Note;
  final String call3DateTime;

  OrderItem({
    required this.name,
    required this.orderId,
    required this.state,
    required this.phone,
    required this.date,
    required this.email,
    required this.orderStatus,
    required this.confirmationStatus,
    required this.totalCall,
    required this.call1EmpName,
    required this.call1Note,
    required this.call1DateTime,
    required this.call2EmpName,
    required this.call2Note,
    required this.call2DateTime,
    required this.call3EmpName,
    required this.call3Note,
    required this.call3DateTime,
  });
}

class OrderList {
  final List<OrderItem> _odrers = [];

  List<OrderItem> get getOrderList {
    return [..._odrers];
  }

  void clearList() {
    _odrers.clear();
  }

  void addOrderItem(
    String id,
    String state,
    String totalCall,
    String name,
    String email,
    String phone,
    String date,
    String orderStatus,
    String confirmationStatus,
    String call1EmpName,
    String call1Note,
    String call1DateTime,
    String call2EmpName,
    String call2Note,
    String call2DateTime,
    String call3EmpName,
    String call3Note,
    String call3DateTime,
  ) {
    _odrers.add(
      OrderItem(
        orderId: id,
        state: state,
        totalCall: totalCall,
        name: name,
        email: email,
        phone: phone,
        date: date,
        orderStatus: orderStatus,
        confirmationStatus: confirmationStatus,
        call1EmpName: call1EmpName,
        call1Note: call1Note,
        call1DateTime: call1DateTime,
        call2EmpName: call2EmpName,
        call2Note: call2Note,
        call2DateTime: call2DateTime,
        call3EmpName: call3EmpName,
        call3Note: call3Note,
        call3DateTime: call3DateTime,
      ),
    );
  }
}
