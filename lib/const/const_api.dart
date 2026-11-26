import 'package:flutter/foundation.dart';

class ConstApi {
  static const baseUrl = kIsWeb
      ? "http://localhost:11434/api/chat"
      : "http://10.0.2.2:11434/api/chat";
  static const modelName = "gemma4:e4b";

  static const systemMessage = {
    "role": "system",
    "content":
        "You are a concise assistant.Most helpful in deep answer and details.",
  };

  ConstApi._();
}
