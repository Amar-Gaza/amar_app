import 'package:flutter_test/flutter_test.dart';
import 'package:amar_app/data/models/ai/ai_chat_form.dart';
import 'package:amar_app/data/models/ai/ai_order_draft.dart';
import 'package:amar_app/data/models/ai/ai_intent.dart';

void main() {
  const form = AiChatForm(
    id: 'sample', purpose: AiDraftStage.product,
    title: 'اختار المنتج والعدد',
    fields: [
      AiFormField(
        key: 'product', label: 'المنتج', type: AiFormType.single,
        choices: [
          AiFormChoice(value: '11', label: 'قاطع كهربائي 20 أمبير'),
          AiFormChoice(value: '12', label: 'قاطع كهربائي 32 أمبير'),
        ],
      ),
      AiFormField(key: 'quantity', label: 'الكمية',
          type: AiFormType.integer, min: 1, max: 20),
    ],
  );

  test('validates server-provided choices and quantity', () {
    expect(form.validate({'product': '11', 'quantity': 2}), isEmpty);
    expect(form.validate({'product': '1000', 'quantity': 2}), contains('product'));
    expect(form.validate({'product': '11', 'quantity': 0}), contains('quantity'));
    expect(form.validate({'product': '11', 'quantity': 100}), contains('quantity'));
    expect(form.validate({'product': '11', 'quantity': 1.5}), contains('quantity'));
  });

  test('form survives local JSON persistence', () {
    final restored = AiChatForm.fromJson(form.toJson());
    expect(restored.purpose, AiDraftStage.product);
    expect(restored.fields.length, 2);
    expect(restored.validate({'product': '12', 'quantity': 3}), isEmpty);
  });

  test('draft retains selected server ids and options without placing order', () {
    final draft = AiOrderDraft(query: 'قاطع كهربائي', quantity: 2, candidates: const [
      AiCatalogItem(id: 11, name: 'قاطع كهربائي', type: 'product', vendorId: 7),
    ]);
    draft
      ..vendorId = 7
      ..productId = 11
      ..addressId = 3
      ..stage = AiDraftStage.review;
    draft.options['amperage'] = ['20a'];
    final restored = AiOrderDraft.fromJson(draft.toJson());
    expect(restored.selectedItem!.id, 11);
    expect(restored.addressId, 3);
    expect(restored.options['amperage'], ['20a']);
    expect(restored.stage, AiDraftStage.review);
  });
}
