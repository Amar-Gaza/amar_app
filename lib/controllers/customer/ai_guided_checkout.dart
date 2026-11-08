
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/routes/route_args.dart';
import '../../data/models/ai/ai_intent.dart';
import '../../data/models/cart/cart_item.dart';
import '../../data/models/catalog/payment_option.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/catalog_service.dart';
import 'ai_task_controller.dart';
import 'cart_controller.dart';
import 'checkout_controller.dart';
import 'product_controller.dart';
import 'shell_controller.dart';

/// Executes a *visible* and *cancellable* draft checkout using real AMAR pages.
/// No final order / payment endpoint is ever invoked by this class.
/// Missing options, conflicting carts, schedule, address or payment method
/// are supplied by the customer through actual Flutter controls.
class AiGuidedCheckout {
  Future<String?> prepare(
      AiCatalogItem suggestion, {
        required int quantity,
        required void Function(String) onProgress,
      }) async {
    final task = Get.find<AiTaskController>();
    final token = task.begin('تجهيز طلب: ${suggestion.name}');
    if (token == null) return 'في مهمة شغالة حالياً؛ أوقفها أو أكملها أولاً.';

    void progress(String message) {
      task.advance(token, message);
      onProgress(message);
    }

    try {
      if (!const {'product', 'service'}.contains(suggestion.type)) {
        return _fail(task, token, 'اختار منتج أو خدمة من النتائج أولاً.');
      }
      if (quantity < 1 || quantity > 20) {
        return _fail(task, token, 'حدّد كمية من 1 إلى 20.');
      }

      progress('1. التحقق من المنتج والمخزون من سيرفر عَمّار');
      final product = await Get.find<CatalogService>()
          .product(suggestion.id)
          .timeout(const Duration(seconds: 25));
      task.check(token);
      if (!product.inStock) {
        return _fail(task, token, 'المنتج غير متوفر حالياً.');
      }
      if (product.vendorId == null) {
        return _fail(task, token, 'المنتج ليس مرتبطاً بمتجر صالح للطلب.');
      }
      if (product.stock != null && product.stock! < quantity) {
        return _fail(task, token, 'الكمية أكبر من المخزون المتاح.');
      }

      // Display the real product details page. Do not fake taps or records.
      progress('2. فتح تفاصيل ${product.name} أمامك');
      Get.toNamed<void>(AppRoutes.product, arguments: ProductArgs(product.id));
      await _waitForProductReady(task, token, product.id);
      await _visiblePause(task, token);

      final selections = <String, List<String>>{};
      for (final option in product.options) {
        task.question(token, 'اختار ${option.label} لـ ${product.name}');
        final chosen = await _askProductOption(option, product.name);
        task.check(token);
        if (chosen == null) {
          return _fail(task, token, 'توقفت المهمة عند اختيار ${option.label}. تقدر تعيد الطلب من الشات.');
        }
        if (option.required && chosen.isEmpty) {
          return _fail(task, token, 'خيار ${option.label} مطلوب لإكمال الطلب.');
        }
        if (chosen.isNotEmpty) selections[option.key] = chosen;
        task.resume(token, 'تم تحديد ${option.label}.');
      }

      final cart = Get.find<CartController>();
      // Never silently replace an unfinished service checkout with a product.
      if (product.kind != 'service' && cart.service.value != null) {
        task.question(token, 'هناك طلب خدمة غير مكتمل. هل نستبدله بطلب المنتج؟');
        final replaceService = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('طلب خدمة قيد التجهيز'),
            content: const Text('اختيار المنتج الجديد سيُنهي تجهيز الخدمة الحالية. هل توافق؟'),
            actions: [
              TextButton(onPressed: () => Get.back(result: false), child: const Text('احتفظ بالخدمة')),
              FilledButton(onPressed: () => Get.back(result: true), child: const Text('تابع مع المنتج')),
            ],
          ),
          barrierDismissible: false,
        );
        task.check(token);
        if (replaceService != true) {
          return _fail(task, token, 'احتفظت بطلب الخدمة بدون تغيير.');
        }
        cart.service.value = null;
        task.resume(token, 'تم اختيار متابعة طلب المنتج.');
      }
      final item = CartItem(product: product, qty: quantity, options: selections);
      final service = product.kind == 'service';

      // Prevent replacing somebody's existing cart without informed consent.
      if (!service && cart.vendorId != null && cart.vendorId != product.vendorId) {
        task.question(token, 'السلة فيها منتجات من متجر مختلف. نستبدلها؟');
        final replace = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('السلة من متجر مختلف'),
            content: const Text('عَمّار يسمح بمتجر واحد لكل طلب. هل توافق على استبدال محتويات السلة الحالية؟'),
            actions: [
              TextButton(onPressed: () => Get.back(result: false), child: const Text('لا، احتفظ بالسلة')),
              FilledButton(onPressed: () => Get.back(result: true), child: const Text('نعم، استبدل السلة')),
            ],
          ),
          barrierDismissible: false,
        );
        task.check(token);
        if (replace != true) {
          return _fail(task, token, 'احتفظت بالسلة الحالية بدون تغيير.');
        }
        cart.replaceWith(item);
      } else if (service) {
        cart.service.value = item;
      } else if (cart.items.isNotEmpty) {
        // Even for the same vendor, avoid surprising the user by silently
        // mixing a new AI order with items from a previous shopping session.
        task.question(token, 'السلة فيها منتجات أخرى. نحتفظ فيها مع الطلب الجديد؟');
        final choice = await Get.dialog<String>(
          AlertDialog(
            title: const Text('السلة فيها منتجات سابقة'),
            content: const Text('بدك تضيف المنتج الجديد للسلة الحالية، أو تجهز طلباً جديداً يحتوي هذا المنتج فقط؟'),
            actions: [
              TextButton(onPressed: () => Get.back(result: 'cancel'), child: const Text('إلغاء')),
              TextButton(onPressed: () => Get.back(result: 'add'), child: const Text('أضف للسلة الحالية')),
              FilledButton(onPressed: () => Get.back(result: 'replace'), child: const Text('طلب جديد فقط')),
            ],
          ),
          barrierDismissible: false,
        );
        task.check(token);
        if (choice == 'replace') {
          cart.replaceWith(item);
        } else if (choice == 'add') {
          if (cart.add(item) != AddToCartResult.added) {
            return _fail(task, token, 'ما قدرت أضيف المنتج للسلة.');
          }
        } else {
          return _fail(task, token, 'احتفظت بالسلة كما هي.');
        }
      } else {
        if (cart.add(item) != AddToCartResult.added) {
          return _fail(task, token, 'ما قدرت أضيف المنتج للسلة.');
        }
      }

      progress('3. أضفت المنتج. عم أعرض السلة والتوصيل');
      CheckoutController? checkout;
      if (service) {
        // The service request route owns its own CheckoutBinding.
        Get.toNamed<void>(AppRoutes.serviceRequest);
        await _visiblePause(task, token);
        checkout = await _checkoutWhenReady(task, token);
      } else {
        if (!Get.isRegistered<ShellController>()) {
          Get.offAllNamed<void>(AppRoutes.home);
          await _visiblePause(task, token);
        } else {
          // Keep the original shell alive to preserve CartTab's controller.
          Get.until((route) => route.settings.name == AppRoutes.home);
        }
        task.check(token);
        if (!Get.isRegistered<ShellController>()) {
          return _fail(task, token, 'تعذر فتح الرئيسية. المنتج محفوظ في السلة.');
        }
        Get.find<ShellController>().select(CustomerTab.cart);
        await _visiblePause(task, token);
        checkout = await _checkoutWhenReady(task, token);
        if (checkout == null) {
          return _fail(task, token, 'السلة جاهزة لكن شاشة التوصيل لم تُحمّل.');
        }
        progress('4. الانتقال إلى شاشة التوصيل الحقيقية');
        Get.toNamed<void>(AppRoutes.checkoutDelivery);
        await _visiblePause(task, token);
      }
      if (checkout == null) {
        return _fail(task, token, 'تعذر فتح نموذج التوصيل.');
      }
      task.check(token);
      // Ensure pricing/merchant metadata reflects the new draft even if
      // CheckoutController was already alive from a prior cart visit.
      await checkout.refreshForAiDraft();
      task.check(token);

      // The checkout controller chooses only the existing default address.
      await _waitForAddressLoad(checkout, task, token);
      if (checkout.address.value == null ||
          (checkout.addresses.length > 1 &&
              !checkout.addresses.any((address) => address.isDefault))) {
        // If there are several addresses with no explicit default, force
        // a new selection instead of silently using the first one.
        if (checkout.addresses.length > 1 &&
            !checkout.addresses.any((address) => address.isDefault)) {
          checkout.address.value = null;
        }
        task.question(token, 'أي عنوان توصيل بدك نستخدم؟ اختاره من الشاشة.');
        await Get.toNamed<void>(AppRoutes.checkoutAddresses);
        task.check(token);
        if (checkout.address.value == null) {
          return _fail(task, token, 'ما تم اختيار عنوان. الطلب لسه بالسلة.');
        }
        task.resume(token, 'تم اختيار عنوان التوصيل.');
      }

      // Services must have an appointment; never fabricate one.
      if (service && checkout.scheduledFor.value == null) {
        task.question(token, 'متى بدك موعد الخدمة؟');
        final when = await _askServiceAppointment();
        task.check(token);
        if (when == null) {
          return _fail(task, token, 'الخدمة تحتاج موعداً قبل حساب السعر.');
        }
        checkout.setSchedule(when);
        task.resume(token, 'تم حفظ موعد الخدمة.');
      }

      // If more than one payment method is valid, ask rather than guess.
      final payments = checkout.paymentOptions;
      if (payments.length > 1 || checkout.paymentMethod.value.isEmpty) {
        task.question(token, 'أي طريقة دفع تفضل؟ الدفع الفعلي يبقى بإيدك.');
        final chosen = await _askPaymentMethod(payments);
        task.check(token);
        if (chosen == null) {
          return _fail(task, token, 'لازم تختار طريقة الدفع قبل عرض السعر.');
        }
        checkout.setPayment(chosen);
        task.resume(token, 'تم اختيار طريقة الدفع.');
      }

      if (!checkout.canRequestQuote) {
        return _fail(
          task,
          token,
          'في معلومات ناقصة للتوصيل أو الموعد أو المرفقات. شاشة التوصيل مفتوحة حتى تكملها.',
        );
      }

      progress('5. طلب السعر الحقيقي من السيرفر');
      final quoted = await checkout.requestQuote()
          .timeout(const Duration(seconds: 30));
      task.check(token);
      if (!quoted || checkout.quote.value == null) {
        return _fail(task, token, 'تعذّر جلب عرض السعر من Masar. راجع تفاصيل التوصيل.');
      }

      progress('6. عرض السعر والشحن أمامك');
      Get.toNamed<void>(AppRoutes.checkoutQuote);
      await _visiblePause(task, token);
      if (checkout.isQuoteExpired) {
        return _fail(task, token, 'انتهت صلاحية السعر. اطلب تحديث عرض السعر.');
      }

      progress('7. الوصول إلى المراجعة النهائية');
      Get.toNamed<void>(AppRoutes.checkoutReview);
      await _visiblePause(task, token);
      task.finish(
        token,
        'المراجعة جاهزة. راجع الإجمالي ${checkout.quote.value!.total.formatted} واضغط تأكيد الطلب بنفسك؛ المساعد لا يدفع أو يرسل الطلب.',
      );
      return 'وصلنا لصفحة المراجعة بالسعر الحقيقي. تأكيد الطلب وإرساله والدفع عليك فقط.';
    } on AiTaskCancelled {
      return 'أوقفت مهمة المساعد. لم يتم إرسال أي طلب أو تنفيذ دفع.';
    } catch (_) {
      return _fail(
        task,
        token,
        'تعذّر إكمال خطوة من الطلب. أي عناصر أُضيفت إلى السلة بقيت للمراجعة.',
      );
    }
  }

  String _fail(AiTaskController task, int token, String explanation) {
    task.fail(token, explanation);
    return explanation;
  }

  Future<void> _visiblePause(AiTaskController task, int token) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    task.check(token);
  }

  Future<void> _waitForProductReady(
      AiTaskController task,
      int token,
      int productId,
      ) async {
    final tag = productId.toString();
    for (var i = 0; i < 45; i++) {
      task.check(token);
      if (Get.isRegistered<ProductController>(tag: tag) &&
          Get.find<ProductController>(tag: tag).product.value != null) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    // The user still sees the actual route; the independent catalog fetch
    // above already validated the product for the task.
  }

  Future<CheckoutController?> _checkoutWhenReady(
      AiTaskController task,
      int token,
      ) async {
    for (var count = 0; count < 40; count++) {
      task.check(token);
      if (Get.isRegistered<CheckoutController>()) {
        return Get.find<CheckoutController>();
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    return null;
  }

  Future<void> _waitForAddressLoad(
      CheckoutController checkout,
      AiTaskController task,
      int token,
      ) async {
    for (var count = 0; count < 200 && checkout.isLoadingAddresses.value; count++) {
      task.check(token);
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    // The existing controller can retry failures using its address UI.
  }

  Future<List<String>?> _askProductOption(
      ProductOption option,
      String productName,
      ) async {
    if (option.choices.isEmpty) {
      return option.required ? null : <String>[];
    }
    if (option.type != ProductOptionType.multi) {
      return Get.dialog<List<String>>(
        AlertDialog(
          title: Text('اختار ${option.label}'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 330, maxWidth: 400),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final choice in option.choices)
                  ListTile(
                    title: Text(choice.label),
                    subtitle: Text(choice.price.formatted),
                    onTap: () => Get.back(result: <String>[choice.key]),
                  ),
              ],
            ),
          ),
          actions: [
            if (!option.required)
              TextButton(onPressed: () => Get.back(result: <String>[]), child: const Text('بدون إضافة')),
            TextButton(onPressed: () => Get.back<List<String>>(), child: const Text('إلغاء')),
          ],
        ),
        barrierDismissible: false,
      );
    }

    final selected = <String>{};
    return Get.dialog<List<String>>(
      StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text('اختار ${option.label}'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 340, maxWidth: 400),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final choice in option.choices)
                  CheckboxListTile(
                    value: selected.contains(choice.key),
                    title: Text(choice.label),
                    subtitle: Text(choice.price.formatted),
                    onChanged: (checked) => update(() {
                      if (checked == true) {
                        selected.add(choice.key);
                      } else {
                        selected.remove(choice.key);
                      }
                    }),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back<List<String>>(), child: const Text('إلغاء')),
            FilledButton(
              onPressed: option.required && selected.isEmpty
                  ? null
                  : () => Get.back(result: selected.toList()),
              child: const Text('متابعة'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<DateTime?> _askServiceAppointment() async {
    final context = Get.context;
    if (context == null) return null;
    final now = DateTime.now();
    final first = DateTime(now.year, now.month, now.day + 1);
    final day = await showDatePicker(
      context: context,
      firstDate: first,
      lastDate: first.add(const Duration(days: 30)),
      initialDate: first,
    );
    if (day == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return null;
    return DateTime(day.year, day.month, day.day, time.hour, time.minute);
  }

  Future<PaymentOption?> _askPaymentMethod(List<PaymentOption> options) async {
    if (options.isEmpty) return null;
    return Get.dialog<PaymentOption>(
      AlertDialog(
        title: const Text('اختار طريقة الدفع (لا يوجد دفع الآن)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options)
              ListTile(
                title: Text(option.gateway?.name ?? option.method),
                onTap: () => Get.back(result: option),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back<PaymentOption>(), child: const Text('إلغاء')),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
