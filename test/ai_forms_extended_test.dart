import 'package:flutter_test/flutter_test.dart';
import 'package:amar_app/data/models/ai/ai_chat_form.dart';
import 'package:amar_app/data/models/ai/ai_order_draft.dart';
import 'package:amar_app/data/models/ai/ai_intent.dart';

void main() {
  const vendorForm = AiChatForm(
    id: 'vendor-1', purpose: AiDraftStage.vendor,
    title: 'من أي متجر؟',
    fields: [
      AiFormField(
        key: 'vendor', label: 'المتجر', type: AiFormType.single,
        choices: [
          AiFormChoice(value: '43', label: 'شركة الكهرباء الحديثة'),
          AiFormChoice(value: '11', label: 'متجر الأمان للأدوات الكهربائية'),
        ],
      ),
    ],
  );

  test('vendor radio accepts only verified option values', () {
    expect(vendorForm.validate({'vendor': '43'}), isEmpty);
    expect(vendorForm.validate({'vendor': '9999'}), contains('vendor'));
    expect(vendorForm.validate({'vendor': ''}), contains('vendor'));
    expect(vendorForm.validate({}), contains('vendor'));
    expect(vendorForm.describe({'vendor': '11'}),
        contains('متجر الأمان للأدوات الكهربائية'));
  });

  test('multi-choice rejects unknown values and duplicates', () {
    const form = AiChatForm(
      id: 'options-1', purpose: AiDraftStage.options,
      title: 'المواصفات',
      fields: [AiFormField(
        key: 'features', label: 'الإضافات', type: AiFormType.multi,
        choices: [
          AiFormChoice(value: 'a', label: 'حماية إضافية'),
          AiFormChoice(value: 'b', label: 'غلاف'),
        ],
      )],
    );
    expect(form.validate({'features': ['a', 'b']}), isEmpty);
    expect(form.validate({'features': ['a', 'a']}), contains('features'));
    expect(form.validate({'features': ['x']}), contains('features'));
    expect(form.validate({'features': []}), contains('features'));
  });

  test('optional multi-choice accepts no selection', () {
    const form = AiChatForm(
      id: 'optional', purpose: AiDraftStage.options,
      title: 'إضافات اختيارية',
      fields: [AiFormField(
        key: 'extras', label: 'إضافات', type: AiFormType.multi,
        required: false,
        choices: [AiFormChoice(value: 'a', label: 'غلاف')],
      )],
    );
    expect(form.validate({'extras': <String>[]}), isEmpty);
  });

  test('quantity accepts integers 1–20, rejects invalid values', () {
    const form = AiChatForm(
      id: 'quantity', purpose: AiDraftStage.product,
      title: 'الكمية',
      fields: [AiFormField(
        key: 'quantity', label: 'الكمية', type: AiFormType.integer,
        min: 1, max: 20,
      )],
    );
    for (final qty in [1, 2, 20, '3']) {
      expect(form.validate({'quantity': qty}), isEmpty);
    }
    for (final qty in [0, 21, -5, 1.5, 'two', null]) {
      expect(form.validate({'quantity': qty}), contains('quantity'));
    }
  });

  test('text fields enforce required and maximum length', () {
    const form = AiChatForm(
      id: 'note', purpose: AiDraftStage.options,
      title: 'ملاحظات',
      fields: [AiFormField(
        key: 'note', label: 'الملاحظة', type: AiFormType.text,
        min: 0, max: 6,
      )],
    );
    expect(form.validate({'note': 'القاطع'}), isEmpty);
    expect(form.validate({'note': ''}), contains('note'));
    expect(form.validate({'note': 'ملاحظة طويلة جداً'}), contains('note'));
  });

  test('form serializes choices without losing real vendor name', () {
    final restored = AiChatForm.fromJson(vendorForm.toJson());
    expect(restored.fields.single.choices.first.label, 'شركة الكهرباء الحديثة');
    expect(restored.validate({'vendor': '43'}), isEmpty);
  });

  test('catalog item parses vendor_name returned by Cloudflare', () {
    final item = AiCatalogItem.fromJson({
      'id': 21, 'type':'product', 'name':'قاطع كهربائي 20 أمبير',
      'vendor_id':43, 'vendor_name':'شركة الكهرباء الحديثة',
      'price':'50 ₪',
    });
    expect(item.vendorId, 43);
    expect(item.vendorName, 'شركة الكهرباء الحديثة');
    expect(AiCatalogItem.fromJson(item.toJson()).vendorName,
        'شركة الكهرباء الحديثة');
  });

  test('catalog rejects invalid ids, invalid kind, and empty product names', () {
    expect(() => AiCatalogItem.fromJson({'id':-1,'type':'product','name':'قاطع'}), throwsFormatException);
    expect(() => AiCatalogItem.fromJson({'id':7,'type':'unsafe','name':'قاطع'}), throwsFormatException);
    expect(() => AiCatalogItem.fromJson({'id':7,'type':'product','name':'  '}), throwsFormatException);
  });

  test('draft round trip preserves vendor, quantity, options, and address', () {
    final draft = AiOrderDraft(query: 'قاطع كهربائي', quantity: 2, candidates: const [
      AiCatalogItem(id: 21, type: 'product', name:'قاطع كهربائي 20 أمبير',
          vendorId:43, vendorName:'شركة الكهرباء الحديثة'),
    ]);
    draft.vendorId=43;
    draft.productId=21;
    draft.addressId=5;
    draft.paymentMethod='cash';
    draft.stage=AiDraftStage.review;
    draft.options['amp']=['20A'];
    draft.vendorNames[43]='شركة الكهرباء الحديثة';
    final restored = AiOrderDraft.fromJson(draft.toJson());
    expect(restored.quantity,2);
    expect(restored.selectedItem?.id,21);
    expect(restored.vendorNames[43], 'شركة الكهرباء الحديثة');
    expect(restored.addressId,5);
    expect(restored.paymentMethod,'cash');
    expect(restored.options['amp'], ['20A']);
    expect(restored.stage,AiDraftStage.review);
  });

  test('gateway reply maps action, quantity and verified product list', () {
    final response = AiGatewayReply.fromJson({
      'ok':true, 'action':'prepare_order', 'reply':'اختار الشركة',
      'results':[{'id':21,'type':'product','name':'قاطع كهربائي',
        'vendor_id':43,'vendor_name':'شركة الكهرباء الحديثة'}],
      'suggestions':['ابحث عن خيار آخر'], 'partial':false, 'quantity':2,
    });
    expect(response.action,'prepare_order');
    expect(response.quantity,2);
    expect(response.results.single.vendorName,'شركة الكهرباء الحديثة');
    expect(response.suggestions, ['ابحث عن خيار آخر']);
  });
}
