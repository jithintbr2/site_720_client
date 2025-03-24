import 'package:flutter/material.dart';
import 'package:site720_client/model/resetPasswordModel.dart';
import 'package:site720_client/screens/login.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class ResetPassword extends StatefulWidget {
  String phoneNumber;
  ResetPassword(this.phoneNumber);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isVisible = true;
  late bool isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formkey,
        child: Container(
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
                            height: 80,
                          ),
                          Center(
                            child: Container(
                              // color: Colors.red,
                              margin: const EdgeInsets.only(bottom: 30),

                              child: Text(
                                "Reset Your Password",
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
                                        controller: password,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: "New Password",
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
                                        obscureText: true,
                                        controller: confirmPassword,
                                        decoration: InputDecoration(
                                          hintText: "Confirm Password",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (password.text.isEmpty) {
                                  Common.toastMessaage(
                                      'New password cannot empty', Colors.red);
                                } else if (password.text !=
                                    confirmPassword.text) {
                                  Common.toastMessaage(
                                      'Password does not match', Colors.red);
                                } else {
                                  Common.showProgressDialog(
                                      context, "Loading..");
                                  ResetPasswordModel reset =
                                      await HttpService.resetPassword(
                                          widget.phoneNumber, password.text);
                                  if (reset.data == true) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    Common.toastMessaage(
                                        'Wrong Password', Colors.red);
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
                                    'Reset',
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
      ),
    );
  }
}
