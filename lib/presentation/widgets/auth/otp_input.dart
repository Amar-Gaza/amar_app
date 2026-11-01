import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'otp_boxes.dart';

/// OTP boxes backed by an invisible field so the system keyboard and
/// SMS autofill work.
class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.controller,
    required this.length,
    required this.value,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int length;
  final String value;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          OtpBoxes(length: length, value: value, hasError: hasError),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: controller,
                autofocus: true,
                showCursor: false,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                maxLength: length,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  // Drop focus before a full code triggers verification, so
                  // no caret callback runs against a field being replaced.
                  if (value.length >= length) {
                    FocusScope.of(context).unfocus();
                  }
                  onChanged(value);
                },
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
          ),
        ],
      );
}
