
import 'package:get/get.dart';

/// Visible, cancellable progress for AMAR's guided UI tasks.
/// The task is local to the running app. It never authorizes order submission.
enum AiTaskPhase { idle, running, waitingForUser, readyForReview, stopped, failed }

class AiTaskCancelled implements Exception {
  const AiTaskCancelled();
}

class AiTaskController extends GetxController {
  final phase = AiTaskPhase.idle.obs;
  final title = ''.obs;
  final detail = ''.obs;
  final steps = <String>[].obs;
  final stepNumber = 0.obs;
  int _generation = 0;
  void Function()? _dismissAiDialog;

  bool get busy => phase.value == AiTaskPhase.running ||
      phase.value == AiTaskPhase.waitingForUser;
  bool get visible => phase.value != AiTaskPhase.idle;

  /// Returns a generation token or null when a task is already active.
  int? begin(String taskTitle) {
    if (busy) return null;
    _generation++;
    title.value = taskTitle;
    detail.value = 'جاري التحقق من بيانات السيرفر...';
    steps.clear();
    stepNumber.value = 0;
    phase.value = AiTaskPhase.running;
    return _generation;
  }

  void check(int token) {
    if (token != _generation ||
        phase.value == AiTaskPhase.stopped ||
        phase.value == AiTaskPhase.idle) {
      throw const AiTaskCancelled();
    }
  }

  void advance(int token, String text) {
    check(token);
    phase.value = AiTaskPhase.running;
    detail.value = text;
    stepNumber.value++;
    steps.add(text);
  }

  void question(int token, String text) {
    check(token);
    phase.value = AiTaskPhase.waitingForUser;
    detail.value = text;
    steps.add('سؤال: $text');
  }

  void resume(int token, String text) {
    check(token);
    phase.value = AiTaskPhase.running;
    detail.value = text;
  }

  void finish(int token, String text) {
    check(token);
    _dismissAiDialog = null;
    detail.value = text;
    steps.add(text);
    phase.value = AiTaskPhase.readyForReview;
  }

  void fail(int token, String text) {
    if (token != _generation || phase.value == AiTaskPhase.stopped) return;
    _dismissAiDialog = null;
    detail.value = text;
    phase.value = AiTaskPhase.failed;
  }

  /// Called only while an assistant-owned selection dialog is visible.
  /// It is deliberately NOT used for payment or unrelated app screens.
  void attachDialogDismissal(void Function()? dismiss) {
    _dismissAiDialog = dismiss;
  }

  void stop() {
    if (!busy) return;
    _generation++;
    final dismiss = _dismissAiDialog;
    _dismissAiDialog = null;
    if (dismiss != null) {
      try { dismiss(); } catch (_) { /* Cancellation remains effective. */ }
    }
    phase.value = AiTaskPhase.stopped;
    detail.value = 'تم إيقاف مهمة المساعد. التغييرات التي أُجريت في السلة لم تُلغَ تلقائياً.';
  }

  void dismiss() {
    if (busy) return;
    _dismissAiDialog = null;
    phase.value = AiTaskPhase.idle;
    steps.clear();
    title.value = '';
    detail.value = '';
  }
}
