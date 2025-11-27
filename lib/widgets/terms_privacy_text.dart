import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../utils/theme.dart';

/// Reusable widget for Terms & Privacy Policy text
class TermsPrivacyText extends StatelessWidget {
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const TermsPrivacyText({
    Key? key,
    this.onTermsTap,
    this.onPrivacyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.unselected_tab_color,
            height: 1.4,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto Flex',
          ),
          children: [
            const TextSpan(text: "By continuing, you agree to our "),
            TextSpan(
              text: "Terms",
              style: const TextStyle(
                color: AppTheme.darkRed,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto Flex',
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = onTermsTap ?? () {
                  debugPrint("Terms clicked");
                },
            ),
            const TextSpan(
              text: " and\n",
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.unselected_tab_color,
                height: 1.4,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto Flex',
              ),
            ),
            TextSpan(
              text: "Privacy Policy",
              style: const TextStyle(
                color: AppTheme.darkRed,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto Flex',
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = onPrivacyTap ?? () {
                  debugPrint("Privacy clicked");
                },
            ),
          ],
        ),
      ),
    );
  }
}

