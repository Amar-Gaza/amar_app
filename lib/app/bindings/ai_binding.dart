import 'package:get/get.dart';

import '../../controllers/customer/ai_action_executor.dart';
import '../../controllers/customer/ai_chat_controller.dart';
import '../../controllers/shared/session_controller.dart';
import '../../core/network/ai_gateway_client.dart';
import '../../core/storage/app_preferences.dart';
import '../../data/services/shared/ai_speech_service.dart';

class AiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiChatController>(
      () => AiChatController(
        Get.find<AiGatewayClient>(),
        Get.find<AppPreferences>(),
        Get.find<SessionController>(),
        AiActionExecutor(),
        Get.find<AiSpeechService>(),
      ),
    );
  }
}
