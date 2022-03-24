import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shopify_firebse/responce/get_model_orderList.dart';
import 'package:shopify_firebse/utils/Constants.dart';
import 'package:shopify_firebse/utils/SharePreferenceUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class ListItemDetailScreen extends StatefulWidget {
  ListItemDetailScreen({required this.orderData, required this.orderKey});
  static const routeName = '/order-details';

  final Orders orderData;
  final String orderKey;

  @override
  State<ListItemDetailScreen> createState() => _ListItemDetailScreenState();
}

class _ListItemDetailScreenState extends State<ListItemDetailScreen> {
  late Orders orders;

  final databaseRef = FirebaseDatabase.instance.ref().child('orderlist');

  String databasejson = '';
  bool isShow = true;
  SessionManager prefs = SessionManager();
  String userid = "", username = "", TAG = "listdetails : ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserid();
    _readDB();
  }

  _getUserid() async {
    prefs.setString("kamal", "bunkar");
    username = await prefs.getString(Constants.USER_NAME, "");
    userid = await prefs.getString(Constants.USER_ID, "");
    String name = await prefs.getString("kamal", "defValue");
    setState(() {
      print(TAG + " username is " + username + "__" + name);
    });
  }

  _readDB() {
    FirebaseDatabase.instance
        .ref('orderlist')
        .child(widget.orderKey)
        .once()
        .then((event) {
      final snapShot = event.snapshot;

      setState(() {
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        orders = Orders.fromJson(json);
        if (orders.totalCall == '') {
          numOfCalls = 0;
        } else {
          numOfCalls = int.parse(orders.totalCall);
        }
        isShow = false;
      });
    });
  }

  _updateDB(
    String id,
    String keyName,
    String textValue,
    String keyEmployeeName,
    String keyDateTime,
    String callsCount,
  ) {
    setState(() {
      databaseRef.child(id).update({
        keyName: textValue,
        keyEmployeeName: username,
        keyDateTime: DateTime.now().toString(),
        'totalcall': callsCount,
      });
    });
    setState(() {});
  }

  int numOfCalls = 0;
  String callNoteValue = 'Call not received';

  @override
  Widget build(BuildContext context) {
    print(TAG + " username " + username);
    return Scaffold(
      backgroundColor: const Color(0xffE8F1FF),
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: isShow
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardTextItem(
                                  title: 'Name: ${widget.orderData.name}'),
                              CardTextItem(
                                  title: (widget.orderData.totalCall != '')
                                      ? 'Total calls: ${orders.totalCall}'
                                      : 'Total calls: No data'),
                              Row(
                                children: [
                                  Text(
                                    'Phone no.: ${widget.orderData.phone}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      await launch(
                                          "tel: ${widget.orderData.phone}");
                                    },
                                    icon: Icon(
                                      Icons.phone,
                                      color: Theme.of(context).primaryColor,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              CardTextItem(
                                  title: (widget.orderData.email != '')
                                      ? 'Email: ${widget.orderData.email}'
                                      : 'Email: Email not filled'),
                              CardTextItem(
                                  title: 'State: ${widget.orderData.state}'),
                              CardTextItem(
                                  title:
                                      'Order Status: ${widget.orderData.orderStatus}'),
                              CardTextItem(
                                  title: (widget.orderData.confirmationStatus !=
                                          '')
                                      ? 'Order Confirmation: ${widget.orderData.confirmationStatus}'
                                      : 'Order Confirmation: No Status'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardTextItem(
                                  title:
                                      'Employee name: ${orders.call1EmpName}'),
                              CardTextItem(
                                  title: 'Employee note: ${orders.call1Note}'),
                              DropdownButton<String>(
                                  value: callNoteValue,
                                  items: [
                                    'Call not received',
                                    'Call not connected/network issue',
                                    'Wrong number',
                                    'Confirmed Order',
                                    'Hold for advance',
                                    'Language issue',
                                    'Cut the call'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      callNoteValue = newValue!;
                                    });
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    numOfCalls++;
                                    _updateDB(
                                      widget.orderData.orderId,
                                      'call1note',
                                      callNoteValue,
                                      'call1_empname',
                                      'call1datetime',
                                      numOfCalls.toString(),
                                    );
                                    _readDB();
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(10.0),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardTextItem(
                                  title:
                                      'Employee name: ${orders.call2EmpName}'),
                              CardTextItem(
                                  title: 'Employee note: ${orders.call2Note}'),
                              DropdownButton<String>(
                                  value: callNoteValue,
                                  items: [
                                    'Call not received',
                                    'Call not connected/network issue',
                                    'Wrong number',
                                    'Confirmed Order',
                                    'Hold for advance',
                                    'Language issue',
                                    'Cut the call'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      callNoteValue = newValue!;
                                    });
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    numOfCalls++;
                                    _updateDB(
                                      widget.orderData.orderId,
                                      'call2note',
                                      callNoteValue,
                                      'call2_empname',
                                      'call2datetime',
                                      numOfCalls.toString(),
                                    );
                                    _readDB();
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(10.0),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardTextItem(
                                  title:
                                      'Employee name: ${orders.call3EmpName}'),
                              CardTextItem(
                                  title: 'Employee note: ${orders.call3Note}'),
                              DropdownButton<String>(
                                  value: callNoteValue,
                                  items: [
                                    'Call not received',
                                    'Call not connected/network issue',
                                    'Wrong number',
                                    'Confirmed Order',
                                    'Hold for advance',
                                    'Language issue',
                                    'Cut the call'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      callNoteValue = newValue!;
                                    });
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    numOfCalls++;
                                    _updateDB(
                                      widget.orderData.orderId,
                                      'call3note',
                                      callNoteValue,
                                      'call3_empname',
                                      'call3datetime',
                                      numOfCalls.toString(),
                                    );
                                    _readDB();
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(10.0),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CardTextItem extends StatelessWidget {
  const CardTextItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
