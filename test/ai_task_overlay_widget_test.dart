import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:amar_app/controllers/customer/ai_task_controller.dart';
import 'package:amar_app/presentation/widgets/ai/ai_task_overlay.dart';

void main() {
  tearDown(() => Get.reset());

  testWidgets('overlay can appear in GetMaterialApp.builder without Tooltip exception', (tester) async {
    final controller = Get.put(AiTaskController());
    await tester.pumpWidget(GetMaterialApp(
      home: const Scaffold(body: Text('Original customer screen')),
      builder: (context, child) => Stack(children: [
        if (child != null) child,
        const AiTaskOverlay(),
      ]),
    ));
    expect(tester.takeException(), isNull);
    final token = controller.begin('تجهيز قاطع كهربائي')!;
    controller.advance(token, 'فتح تفاصيل المنتج');
    await tester.pump();
    expect(find.text('تجهيز قاطع كهربائي'), findsOneWidget);
    expect(find.text('Original customer screen'), findsOneWidget);
    expect(tester.takeException(), isNull);
    controller.finish(token, 'جاهز للمراجعة');
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
