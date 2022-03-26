import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shopify_firebse/model/order_list_model.dart';
import 'package:shopify_firebse/responce/get_model_orderList.dart';
import 'package:shopify_firebse/utils/Constants.dart';
import 'package:shopify_firebse/utils/SharePreferenceUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class ListItemDetailScreen extends StatefulWidget {
  ListItemDetailScreen({required this.orderData, required this.orderKey});
  static const routeName = '/order-details';

  final OrderItem orderData;
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
    if (widget.orderData.call1Note != '') {
      _showDropdown1 = false;
    }
    if (widget.orderData.call2Note != '') {
      _showDropdown2 = false;
    }
    if (widget.orderData.call3Note != '') {
      _showDropdown3 = false;
    }
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
  String callNoteValue1 = 'Call not received';
  String callNoteValue2 = 'Call not received';
  String callNoteValue3 = 'Call not received';
  bool _showDropdown1 = true;
  bool _showDropdown2 = true;
  bool _showDropdown3 = true;

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
                                title: 'Order ID: ${widget.orderData.orderId}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CardTextItem(
                                title: 'Name: ${widget.orderData.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              CardTextItem(
                                title: (widget.orderData.totalCall != '')
                                    ? 'Total calls: ${orders.totalCall}'
                                    : 'Total calls: No data',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
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
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                              CardTextItem(
                                title: 'State: ${widget.orderData.state}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              CardTextItem(
                                title:
                                    'Order Status: ${widget.orderData.orderStatus}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              CardTextItem(
                                title: (widget.orderData.confirmationStatus !=
                                        '')
                                    ? 'Order Confirmation: ${widget.orderData.confirmationStatus}'
                                    : 'Order Confirmation: No Status',
                                style: const TextStyle(
                                  fontSize: 18,
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
                                title: 'Employee name: ${orders.call1EmpName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              CardTextItem(
                                title: 'Employee note: ${orders.call1Note}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              _showDropdown1
                                  ? DropdownButton<String>(
                                      value: callNoteValue1,
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
                                          callNoteValue1 = newValue!;
                                        });
                                      })
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              _showDropdown1
                                  ? Container(
                                      width: double.infinity,
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: () {
                                          numOfCalls++;
                                          _updateDB(
                                            widget.orderData.orderId,
                                            'call1note',
                                            callNoteValue1,
                                            'call1_empname',
                                            'call1datetime',
                                            numOfCalls.toString(),
                                          );
                                          _readDB();
                                          setState(() {
                                            _showDropdown1 = false;
                                          });
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.all(10.0),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                    )
                                  : Container(),
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
                                title: 'Employee name: ${orders.call2EmpName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              CardTextItem(
                                title: 'Employee note: ${orders.call2Note}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              _showDropdown2
                                  ? DropdownButton<String>(
                                      value: callNoteValue2,
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
                                          callNoteValue2 = newValue!;
                                        });
                                      })
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              _showDropdown2
                                  ? Container(
                                      width: double.infinity,
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: () {
                                          numOfCalls++;
                                          _updateDB(
                                            widget.orderData.orderId,
                                            'call2note',
                                            callNoteValue2,
                                            'call2_empname',
                                            'call2datetime',
                                            numOfCalls.toString(),
                                          );
                                          _readDB();
                                          setState(() {
                                            _showDropdown2 = false;
                                          });
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.all(10.0),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                    )
                                  : Container(),
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
                                title: 'Employee name: ${orders.call3EmpName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              CardTextItem(
                                title: 'Employee note: ${orders.call3Note}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              _showDropdown3
                                  ? DropdownButton<String>(
                                      value: callNoteValue3,
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
                                          callNoteValue3 = newValue!;
                                        });
                                      })
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              _showDropdown3
                                  ? Container(
                                      width: double.infinity,
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: () {
                                          numOfCalls++;
                                          _updateDB(
                                            widget.orderData.orderId,
                                            'call3note',
                                            callNoteValue3,
                                            'call3_empname',
                                            'call3datetime',
                                            numOfCalls.toString(),
                                          );
                                          _readDB();
                                          setState(() {
                                            _showDropdown3 = false;
                                          });
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.all(10.0),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                    )
                                  : Container(),
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
    required this.style,
  }) : super(key: key);

  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        title,
        style: style,
      ),
    );
  }
}
