
import 'package:flutter_test/flutter_test.dart';

import 'package:amar_app/data/models/ai/ai_chat_message.dart';
import 'package:amar_app/data/models/ai/ai_intent.dart';

void main() {
  test(
    'AI can prepare order draft without payment',
        () {
      final result =
      AiGatewayReply.fromJson({
        'ok': true,
        'action': 'prepare_order',
        'reply':
        'اختار المنتج لتجهيز الطلب',
        'results': [
          {
            'id': 11,
            'type': 'product',
            'name': 'كورس إفرنجي',
            'price': '30 ₪',
          },
        ],
        'quantity': 2,
        'suggestions': [],
        'partial': false,
      });

      expect(
        result.action,
        'prepare_order',
      );

      expect(
        result.quantity,
        2,
      );

      expect(
        result.results.single.id,
        11,
      );
    },
  );

  test(
    'Order draft is saved in chat history',
        () {
      final message = AiChatMessage(
        role: 'assistant',
        text: 'لقيت المنتج',
        createdAt: DateTime(
          2026,
          11,
          8,
        ),
        canPrepareOrder: true,
        orderQuantity: 2,
        results: const [
          AiCatalogItem(
            id: 11,
            type: 'product',
            name: 'كورس إفرنجي',
          ),
        ],
      );

      final restored =
      AiChatMessage.fromJson(
        message.toJson(),
      );

      expect(
        restored.canPrepareOrder,
        true,
      );

      expect(
        restored.orderQuantity,
        2,
      );

      expect(
        restored.results.single.name,
        'كورس إفرنجي',
      );
    },
  );

  test(
    'AI cannot perform payment or submit orders',
        () {
      final forbiddenActions = [
        'pay_now',
        'place_order',
        'confirm_order',
      ];

      for (
      final action in forbiddenActions
      ) {
        expect(
              () => AiGatewayReply.fromJson({
            'ok': true,
            'action': action,
            'reply': 'done',
            'results': [],
          }),
          throwsFormatException,
        );
      }
    },
  );
}
