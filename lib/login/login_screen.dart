import 'package:flutter/material.dart';
import 'package:shopify_firebse/screens/home_screen.dart';
import 'package:shopify_firebse/responce/get_model_userLogin.dart';
import 'package:shopify_firebse/utils/Constants.dart';
import 'package:shopify_firebse/webservice/servicewrapper.dart';
import '../utils/SharePreferenceUtils.dart';
import '../widgets/custom_txtformfield.dart';
import 'package:shopify_firebse/widgets/signin_button.dart';

import '../widgets/signup_row.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Servicewrapper wrapper = Servicewrapper();
  late GetModelUserlogin _loginModel;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  height: height,
                  child: Image.asset(
                    'assets/images/building.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: height * 0.3,
                  child: Container(
                    height: height * 0.7,
                    width: width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            controller: _mobileNumberController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                              counterText: '',
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                            onSaved: (value) =>
                                _mobileNumberController.text = value!,
                            validator: (val) => val!.isEmpty
                                ? 'Empty Field'
                                : val.length != 10
                                    ? 'Invalid Number'
                                    : null,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                            onSaved: (value) =>
                                _passwordController.text = value!,
                            validator: (val) =>
                                val!.isEmpty ? 'Empty Password' : null,
                          ),
                          const SizedBox(
                            height: 36,
                          ),
                          SingInButton(
                              width: width,
                              onTapHandler: () {
                                _onSubmitHander();
                              }
                              /* => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => HomeScreen(),
                              ),
                            ),*/
                              ),
                          const SizedBox(
                            height: 16,
                          ),
                          const CustomSignUpRow(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitHander() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final Map<String, dynamic> parsed = await wrapper.user_login(
          _mobileNumberController.text, _passwordController.text);
      _loginModel = GetModelUserlogin.fromJson(parsed);

      if (_loginModel.status == 1) {
        SessionManager prefs = SessionManager();

        String nnn = _loginModel.information.fullname.toString();
        String newName = _loginModel.information.userId;
        print('newName---$newName');
        //changed .toString()
        prefs.setString(Constants.USER_ID, _loginModel.information.userId);
        prefs.setString(Constants.USER_NAME, _loginModel.information.fullname);
        prefs.setString("empname", nnn);
        prefs.setString("kamal", "bunkar");
        //changed .toString()
        prefs.setString(Constants.USER_PHONE, _loginModel.information.phone);

        //changed .toString()
        print("Login : " +
            "  username " +
            _loginModel.information.fullname +
            "--- " +
            nnn);

        String name = await prefs.getString("kamal", "defValue");
        // String  username = await prefs.getString("USERNAME", "");
        print("Login : " + " username is " + "--" + name);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => HomeScreen()),
          ),
        );
      } else {
        // alert( show error msg )
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Invalid Phone number or Password'),
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
      }
    }
  }
}




// prefs.setString(Constants.USER_ID, model.information.user_Id.toString());
//       prefs.setString(Constants.USER_UNIQUE_ID, model.information.user_Id.toString());
//       //prefs.setString(Constants.QOUTE_ID, model.information.qouteid.toString());
//       prefs.setString(Constants.QOUTE_ID, "");
//       prefs.setString(Constants.USER_NAME, model.information.name.toString());
//       prefs.setString(Constants.USER_PHONE, model.information.phone.toString());