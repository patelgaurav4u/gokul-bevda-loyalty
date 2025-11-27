import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  OtpInput({required this.controller, this.length = 6});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      keyboardType: TextInputType.number,
      appContext: context,
      controller: controller,
      length: length,
      onChanged: (v) {},
      pinTheme: PinTheme(shape: PinCodeFieldShape.box),
    );
  }
}
