import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/loginModel.dart';
import 'package:site720_client/screens/client_profile/pin_entry_screen.dart';
import 'package:site720_client/screens/dashboard.dart';
import 'package:site720_client/screens/phoneNumberPage.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class Login extends StatefulWidget {
  final String? userPin;
  const Login({
    super.key,
    this.userPin,
  });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isVisible = true;
  late bool isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? firebaseToken;
  String? currentPin;

  handleAsync() async {
    firebaseToken = await FirebaseMessaging.instance.getToken();
    //print("Firebase token : $firebaseToken");
    // firebaseToken='123';

    // firebaseToken = await FirebaseMessaging.instance.getToken();
    // print("Firebase token : $firebaseToken");
    // firebaseToken='123';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPin = widget.userPin;
    // firebase = FirebaseNotifcation();
    handleAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 180,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Center(
            child: InkWell(
              onTap: () async {
                // Clear existing PIN from shared preferences
                await Common.clearPinVerification();

                if (mounted) {
                  setState(() {
                    currentPin = null;
                  });
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PinEntryScreen(
                      onComplete: (success, message) async {
                        if (success) {
                          // Fetch the newly set PIN
                          String? newPin = await Common.getUserPin();
                          if (mounted) {
                            setState(() {
                              currentPin = newPin;
                            });
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_reset_rounded,
                      size: 18,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "RESET PIN",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 230, 195, 204),
      body: Form(
        key: formkey,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 100),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(Assets.whiteLogo),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Center(
                            child: Container(
                              // color: Colors.red,
                              margin: const EdgeInsets.only(bottom: 30),

                              child: Text(
                                "Login to your account",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(221, 31, 28, 28),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: double.infinity,
                              height: 45,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        maxLines: 1,
                                        controller: username,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "Username",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              width: double.infinity,
                              height: 45,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        maxLines: 1,
                                        // obscureText: true,
                                        controller: password,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (username.text.isEmpty) {
                                  Common.toastMessaage(
                                      'Enter Username', Colors.red);
                                } else if (password.text.isEmpty) {
                                  Common.toastMessaage(
                                      'Enter Password', Colors.red);
                                } else {
                                  Common.showProgressDialog(
                                      context, "Loading..");
                                  LoginModel object = await HttpService.login(
                                      currentPin,
                                      username.text,
                                      password.text,
                                      firebaseToken);
                                  if (object.status == true) {
                                    Common.toastMessaage(
                                        object.message, Colors.green);
                                    Common.saveSharedPref(
                                        "token", object.data!.token.toString());
                                    Common.saveSharedPref("name",
                                        object.data!.username.toString());
                                    Common.saveSharedPref("plan",
                                        object.data!.planImg.toString());
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard(
                                                token: object.data!.token
                                                    .toString())),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    Common.toastMessaage(
                                        object.message, Colors.red);
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [Colors.black, Colors.black]),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  width: 500,
                                  height: 45,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Add a button to go back to Pin Entry Screen
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 10),
                          //   child: OutlinedButton.icon(
                          //     icon: Icon(Icons.lock_outline),
                          //     label: Text('Re-enter PIN'),
                          //     style: OutlinedButton.styleFrom(
                          //       side: BorderSide(color: Colors.black),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       foregroundColor: Colors.black,
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 12, horizontal: 16),
                          //     ),
                          //     onPressed: () {
                          //       Navigator.pushReplacement(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => PinEntryScreen(
                          //             onComplete: (success, message) {
                          //               if (success) {
                          //                 Navigator.pop(context);
                          //               }
                          //             },
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 15, right: 15),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     children: [
                          //       InkWell(
                          //         onTap: () {
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     PhoneNumberPage()),
                          //           );
                          //         },
                          //         child: RichText(
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: "Forgot Password ?",
                          //                 style: TextStyle(
                          //                   color: const Color.fromARGB(
                          //                       255, 255, 255, 255),
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
