import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/changePasswordModel.dart';
import 'package:site720_client/screens/login.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class ChangePassword extends StatefulWidget {
  String token;
  ChangePassword(this.token);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isVisible = true;
  late bool isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? firebaseToken;
  handleAsync() async {
    firebaseToken = await FirebaseMessaging.instance.getToken();
    print("Firebase token : $firebaseToken");
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    handleAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Change Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(Assets.logo),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Container(
                            // color: Colors.red,
                            margin: const EdgeInsets.only(bottom: 30),

                            child: Text(
                              "Change Password",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      controller: newPassword,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: "Email",
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      obscureText: true,
                                      controller: confirmPassword,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (newPassword.text.isEmpty) {
                                Common.toastMessaage(
                                    'Enter New Password', Colors.red);
                              } else if (newPassword.text !=
                                  confirmPassword.text) {
                                Common.toastMessaage(
                                    'Password Not Match', Colors.red);
                              } else {
                                Common.showProgressDialog(context, "Loading..");
                                ChangePasswordModel object =
                                    await HttpService.login(widget.token,
                                        confirmPassword.text, firebaseToken);
                                if (object.status == true) {
                                  Common.toastMessaage(
                                      object.message, Colors.green);
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
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
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
