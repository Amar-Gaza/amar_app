
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/customer/ai_task_controller.dart';

/// Above the Navigator so the user watches the REAL AMAR routes move beneath it.
class AiTaskOverlay extends StatelessWidget {
  const AiTaskOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AiTaskController>()) {
      return const SizedBox.shrink();
    }
    final task = Get.find<AiTaskController>();
    return Obx(() {
      if (!task.visible) return const SizedBox.shrink();
      final active = task.busy;
      final colors = Theme.of(context).colorScheme;
      return Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
            child: Material(
              elevation: 7,
              borderRadius: BorderRadius.circular(16),
              color: colors.surface,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 510),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(children: [
                    Icon(
                      task.phase.value == AiTaskPhase.readyForReview
                          ? Icons.check_circle_outline
                          : task.phase.value == AiTaskPhase.waitingForUser
                          ? Icons.help_outline
                          : task.phase.value == AiTaskPhase.failed
                          ? Icons.error_outline
                          : Icons.smart_toy_outlined,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(task.title.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelLarge),
                          Text(task.detail.value,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall),
                          if (active &&
                              task.phase.value == AiTaskPhase.running) ...[
                            const SizedBox(height: 6),
                            const LinearProgressIndicator(minHeight: 2),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.receipt_long_outlined),
                      onPressed: () => Get.dialog<void>(
                        AlertDialog(
                          title: const Text('خطوات المساعد'),
                          content: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 280),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (final step in task.steps)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Text('• $step'),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back<void>(),
                              child: const Text('إغلاق'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: active ? task.stop : task.dismiss,
                      child: Text(active ? 'إيقاف' : 'إغلاق'),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
