import 'package:chat_gpt/core/api_key.dart';
import 'package:dio/dio.dart';

class ChatGptRepository {
  final Dio _dio;

  ChatGptRepository(Dio dio) : _dio = dio;

  Future<String> promptMessage(String promp) async {
    try {
      const url = 'https://api.openai.com/v1/completions';

      final response = await _dio.post(url,
          data: {
            'model': 'text-davinci-003',
            "prompt": promp,
            "max_tokens": 1000,
            "temperature": 0,
            "top_p": 1,
            "frequency_penalty": 0.0,
            "presence_penalty": 0.0,
          },
          options: Options(headers: {'Authorization': 'Bearer ${ApiKey.getopenAIAPIKEY}'}));
      return response.data['choices'][0]['text'];
    } catch (e) {
      return 'Erro ao enviar mensagem';
    }
  }
}
