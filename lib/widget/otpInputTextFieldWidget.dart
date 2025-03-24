import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class OtpInputTextFieldWidget extends StatelessWidget {
  const OtpInputTextFieldWidget({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;


  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: controller,
      appContext: context,
      length: 6,
      obscureText: false,
      keyboardType: TextInputType.number,
      textStyle: const TextStyle(color: Colors.black),
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(7),
        selectedColor: Color(0xB3000000),
        activeColor: Color(0xB3000000),
        inactiveColor: Color(0xB3000000),
        fieldHeight: 52,
        fieldWidth: 49,
        activeFillColor: Colors.transparent,
      ),
      onChanged: (String value) {},
    );
  }
}
