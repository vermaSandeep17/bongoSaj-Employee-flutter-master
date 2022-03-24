import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopify_firebse/login/login_screen.dart';
import 'package:shopify_firebse/screens/home_screen.dart';
import 'package:shopify_firebse/screens/listitemdetail_screen.dart';
import 'package:shopify_firebse/utils/SharePreferenceUtils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  String userId = '';

  // getSharedData() async {
  //   SessionManager prefs = SessionManager();
  //   name = await prefs.getString("kamal", "defValue");
  //   print('Name --- $name');
  // }

  bool isLoggedIn = false;
  String name = '';

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    SessionManager prefs = SessionManager();
    userId = await prefs.getString("kamal", "defValue");

    if (userId != '') {
      setState(() {
        isLoggedIn = true;
        name = userId;
        print('Name---$name');
        print(isLoggedIn);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // getSharedData();
    return MaterialApp(
      title: 'BongoSaj Emp',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: !isLoggedIn ? LogInScreen() : HomeScreen(),
    );
  }
}
