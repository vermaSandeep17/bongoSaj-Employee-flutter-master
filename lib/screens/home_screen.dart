import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shopify_firebse/login/login_screen.dart';
import 'package:shopify_firebse/responce/get_model_orderList.dart';
import 'package:shopify_firebse/screens/listitemdetail_screen.dart';
import 'package:shopify_firebse/utils/SharePreferenceUtils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseRef = FirebaseDatabase.instance.ref().child('orderlist');
  final TextEditingController _controllerSearch = TextEditingController();

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
                    // height: 80,
                    width: 280,
                    child: TextField(
                      controller: _controllerSearch,
                      onSubmitted: (value) {
                        setState(() {
                          _controllerSearch.text = value;
                        });
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
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
                        });
                        print(_showOnly);
                        print('object---' + _controllerSearch.text);
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
      body: FirebaseAnimatedList(
        query: _showOnly ? getSearchedListQuery() : getOrderListQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final orders = Orders.fromJson(json);
          print(TAG + ' controller text ' + _controllerSearch.text);
          if (_controllerSearch.text != '') {
            var justTry = databaseRef.child(_controllerSearch.text);
            justTry.once().then(
                  (event) => print(TAG +
                      ' --Firebase Single Search-- ' +
                      event.snapshot.value.toString()),
                );
            print('query ----$justTry');
          }

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => ListItemDetailScreen(
                        orderData: orders,
                        orderKey: orders.orderId,
                      )),
                ),
              );
            },
            child: SingleListItem(orders: orders),
          );
        },
      ),
    );
  }
}

class SingleListItem extends StatelessWidget {
  const SingleListItem({
    Key? key,
    required this.orders,
  }) : super(key: key);

  final Orders orders;

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
