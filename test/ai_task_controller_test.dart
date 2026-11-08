
import 'package:flutter_test/flutter_test.dart';
import 'package:amar_app/controllers/customer/ai_task_controller.dart';

void main() {
  test('shows steps, waits for customer, stops at review', () {
    final task = AiTaskController();
    final token = task.begin('تجهيز منتج')!;
    task.advance(token, 'جلب المنتج');
    task.advance(token, 'فتح السلة');
    expect(task.stepNumber.value, 2);
    expect(task.busy, true);
    task.question(token, 'اختار العنوان');
    expect(task.phase.value, AiTaskPhase.waitingForUser);
    task.resume(token, 'تم اختيار العنوان');
    task.finish(token, 'جاهز للمراجعة النهائية');
    expect(task.phase.value, AiTaskPhase.readyForReview);
    expect(task.busy, false);
  });

  test('cancellation invalidates the task generation', () {
    final task = AiTaskController();
    final token = task.begin('تجهيز منتج')!;
    task.advance(token, 'فتح المنتج');
    task.stop();
    expect(() => task.check(token), throwsA(isA<AiTaskCancelled>()));
    expect(task.phase.value, AiTaskPhase.stopped);
  });

  test('a second task cannot start while one is active', () {
    final task = AiTaskController();
    final token = task.begin('طلب أول');
    expect(token, isNotNull);
    expect(task.begin('طلب ثان'), isNull);
  });
}
