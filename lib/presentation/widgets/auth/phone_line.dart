import 'package:flutter/material.dart';

import '../../../core/theme/theme_context.dart';
import '../common/link_button.dart';

/// The number the code was sent to, with a change-number link.
class PhoneLine extends StatelessWidget {
  const PhoneLine({
    super.key,
    required this.phone,
    required this.changeLabel,
    required this.onChange,
  });

  final String phone;
  final String changeLabel;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            phone,
            textDirection: TextDirection.ltr,
            style: context.text.titleSmall,
          ),
          LinkButton(label: changeLabel, onPressed: onChange),
        ],
      );
}
