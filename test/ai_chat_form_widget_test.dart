import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amar_app/data/models/ai/ai_chat_form.dart';
import 'package:amar_app/presentation/widgets/ai/ai_chat_form_card.dart';

void main() {
  testWidgets('narrow chat radio choices and quantity submit correct IDs', (tester) async {
    Map<String, dynamic>? captured;
    const form = AiChatForm(
      id: 'form-small', purpose: 'product', title: 'اختار المنتج والعدد',
      fields: [
        AiFormField(key: 'product', label: 'المنتج', type: AiFormType.single,
          choices: [
            AiFormChoice(value: '21', label: 'قاطع كهربائي 20 أمبير'),
            AiFormChoice(value: '22', label: 'قاطع كهربائي 32 أمبير'),
          ]),
        AiFormField(key: 'quantity', label: 'الكمية', type: AiFormType.integer,
          initialNumber:2, min:1, max:20),
      ],
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Center(
      child: SizedBox(width: 310, child: SingleChildScrollView(
        child: AiChatFormCard(form: form, enabled: true, onSubmit: (value) async {
          captured = value;
          return true;
        }),
      )),
    ))));
    expect(tester.takeException(), isNull); // Catches unconstrained-width issues.
    await tester.tap(find.text('قاطع كهربائي 32 أمبير'));
    await tester.pump();
    await tester.ensureVisible(find.text('متابعة'));
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(captured?['product'], '22');
    expect(captured?['quantity'], 2);
  });

  testWidgets('required radio cannot submit without answer', (tester) async {
    var called = false;
    const form = AiChatForm(id:'required', purpose:'vendor', title:'اختار الشركة', fields:[
      AiFormField(key:'vendor',label:'المتجر',type:AiFormType.single,
        choices:[AiFormChoice(value:'43', label:'شركة الكهرباء الحديثة')]),
    ]);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: SingleChildScrollView(
      child: AiChatFormCard(form:form,enabled:true,onSubmit:(answer) async {
        called=true; return true;
      }),
    ))));
    await tester.tap(find.text('متابعة'));
    await tester.pump();
    expect(called, isFalse);
    expect(find.text('اختار واحد من الخيارات'), findsOneWidget);
  });

  testWidgets('answered form cannot submit again', (tester) async {
    var called = false;
    const form = AiChatForm(id:'answered',purpose:'vendor',title:'الشركة',fields:[
      AiFormField(key:'vendor',label:'المتجر',type:AiFormType.single,
        choices:[AiFormChoice(value:'43',label:'شركة الكهرباء الحديثة')]),
    ]);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: AiChatFormCard(
      form: form, enabled: false, onSubmit: (_) async {called = true; return true;},
    ))));
    final button = tester.widget<FilledButton>(find.byType(FilledButton).last);
    expect(button.onPressed, isNull);
    expect(called, isFalse);
  });
}
