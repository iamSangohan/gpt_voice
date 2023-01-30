import 'dart:convert';
import 'package:http/http.dart' as http;

String api_key = "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";

class GPTApi {
  static String base_url = "https://api.openai.com/v1/completions";

  static Map<String, String> header = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Authorization': 'Bearer $api_key',
  };

  static sendMessage(String? message) async {
    var res = await http.post(Uri.parse(base_url),
        headers: header,
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": '$message',
          "temperature": 0,
          'max_tokens': 100,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "stop": [" Human:", " AI:"]
        }));

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      var msg = data['choices'][0]['text'];
      return msg;
    } else {
      print("Failed to load data");
    }
  }
}
