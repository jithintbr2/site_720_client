import 'dart:math';

import 'package:flutter/material.dart';
import 'package:site720_client/model/phoneNumberCheck.dart';
import 'package:site720_client/model/sendOtpModel.dart';
import 'package:site720_client/screens/OtpScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({Key? key}) : super(key: key);

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  TextEditingController phoneNumber = new TextEditingController();
  bool isVisible = true;
  late bool isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void initState() {
    // TODO: implement initState
    super.initState();
    // firebase = FirebaseNotifcation();

    //handleAsync();
  }

  @override
  Widget build(BuildContext context) {
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
                                "Verify Your Phone Number",
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
                                        controller: phoneNumber,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "Phone Number",
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
                                if (phoneNumber.text.isEmpty) {
                                  Common.toastMessaage(
                                      'Enter Phone Number', Colors.red);
                                } else {
                                  Common.showProgressDialog(
                                      context, "Loading..");
                                  PhoneNumberCheck object =
                                      await HttpService.phoneNumberCheck(
                                          phoneNumber.text);
                                  if (object.status == true) {
                                    int min =
                                        1000; //min and max values act as your 6 digit range
                                    int max = 9999;
                                    var randomizer = new Random();
                                    var rNum =
                                        min + randomizer.nextInt(max - min);
                                    SendOtpModel otp =
                                        await HttpService.sendOtp(
                                            phoneNumber.text, rNum);
                                    if (otp.data == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtpVerificationScreen(
                                                    phoneNumber.text,
                                                    rNum.toString())),
                                      );
                                    } else {
                                      Common.toastMessaage(
                                          otp.message, Colors.red);
                                      Navigator.pop(context);
                                    }
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
      ),
    );
  }
}
