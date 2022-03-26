import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shopify_firebse/login/login_screen.dart';
import 'package:shopify_firebse/model/order_list_model.dart';
import 'package:shopify_firebse/responce/get_model_orderList.dart';
import 'package:shopify_firebse/screens/listitemdetail_screen.dart';
import 'package:shopify_firebse/utils/SharePreferenceUtils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _readDB();
    super.initState();
  }

  final databaseRef = FirebaseDatabase.instance.ref().child('orderlist');
  final TextEditingController _controllerSearch = TextEditingController();

  late Orders orders;
  OrderList orderList = OrderList();

  bool _showOnly = false;
  Query getOrderListQuery() {
    return databaseRef;
  }

  String TAG = "Home Screen";

  Query getSearchedListQuery() {
    return databaseRef.child('IK3326');
  }

  bool isShowing = true;

  Future getOrderListDetails() async {
    return databaseRef;
  }

  List<OrderItem> orderItemList = [];

  bool _isGetData = true;

  _readDB() {
    if (_showOnly) {
      FirebaseDatabase.instance
          .ref('orderlist')
          .child(_controllerSearch.text)
          .once()
          .then((event) {
        setState(() {
          if (event.snapshot.value != null) {
            orderList.clearList();
            final json = event.snapshot.value as Map<dynamic, dynamic>;
            orders = Orders.fromJson(json);
            orderList.addOrderItem(
              orders.orderId,
              orders.state,
              orders.totalCall,
              orders.name,
              orders.email,
              orders.phone,
              orders.date,
              orders.orderStatus,
              orders.confirmationStatus,
              orders.call1EmpName,
              orders.call1Note,
              orders.call1DateTime,
              orders.call2EmpName,
              orders.call2Note,
              orders.call2DateTime,
              orders.call3EmpName,
              orders.call3Note,
              orders.call3DateTime,
            );

            orderItemList = orderList.getOrderList;

            setState(() {
              isShowing = false;
            });
          } else {
            setState(() {
              _isGetData = false;
            });
          }
        });
      });
    } else {
      FirebaseDatabase.instance.ref('orderlist').once().then((event) {
        setState(() {
          if (event.snapshot.value != null) {
            orderList.clearList();
            final response = event.snapshot.value as Map<dynamic, dynamic>;
            response.forEach((orderId, orderData) {
              final json = orderData as Map<dynamic, dynamic>;
              orders = Orders.fromJson(json);
              orderList.addOrderItem(
                orders.orderId,
                orders.state,
                orders.totalCall,
                orders.name,
                orders.email,
                orders.phone,
                orders.date,
                orders.orderStatus,
                orders.confirmationStatus,
                orders.call1EmpName,
                orders.call1Note,
                orders.call1DateTime,
                orders.call2EmpName,
                orders.call2Note,
                orders.call2DateTime,
                orders.call3EmpName,
                orders.call3Note,
                orders.call3DateTime,
              );
            });
            orderItemList = orderList.getOrderList;

            setState(() {
              isShowing = false;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              SessionManager prefs = SessionManager();
              prefs.removeString("kamal");
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: ((context) => LogInScreen()),
              ));
            },
            icon: Icon(Icons.logout),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 45,
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    width: 280,
                    child: TextField(
                      controller: _controllerSearch,
                      onSubmitted: (value) {
                        setState(() {
                          _controllerSearch.text = value;
                        });
                        if (_controllerSearch.text == '') {
                          setState(() {
                            _showOnly = false;
                            _isGetData = true;
                          });
                          _readDB();
                        }
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: _controllerSearch.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _controllerSearch.clear();
                                  });
                                  if (_controllerSearch.text == '') {
                                    setState(() {
                                      _showOnly = false;
                                      _isGetData = true;
                                    });
                                    _readDB();
                                  }
                                },
                              ),
                        label: Text('Search'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controllerSearch.text == '') {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Empty Search'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            });
                      } else {
                        setState(() {
                          _showOnly = true;
                          _isGetData = true;
                        });
                        _readDB();
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: isShowing
          ? Center(child: CircularProgressIndicator())
          : _isGetData
              ? ListView.builder(
                  itemCount: orderItemList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: GestureDetector(
                          child: SingleListItem(orders: orderItemList[index]),
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: ((context) => ListItemDetailScreen(
                                          orderData: orderItemList[index],
                                          orderKey:
                                              orderItemList[index].orderId,
                                        )),
                                  ),
                                )
                                .then((value) => _readDB());
                          }),
                    );
                  },
                )
              : Container(
                  child: Center(
                    child: Text('Enter Valid Order Id'),
                  ),
                ),
    );
  }
}

class SingleListItem extends StatelessWidget {
  const SingleListItem({
    Key? key,
    required this.orders,
  }) : super(key: key);

  final OrderItem orders;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order id: ${orders.orderId}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'State: ${orders.state}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Total Calls: ${orders.totalCall}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
