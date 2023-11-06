import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:allen/secret.dart';

class OpenAIservice {
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIkey ',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
                  "Does this message want to genrate an AI picture, image, art or anything simillar? $prompt . Simply say yes or no. "
            }
          ]
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        print('yay');
      }
      return 'AI';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatAPI(String promt) async {
    return 'ChatGPT';
  }

  Future<String> callEAPI(String promt) async {
    return 'DallE';
  }
}
