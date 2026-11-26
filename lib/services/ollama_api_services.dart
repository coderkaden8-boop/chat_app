import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:my_ollama_projects/const/const_api.dart';

import '../model/RequestOllamaApi.dart';
import '../model/ResponseOllamaApi.dart';

class OllamaApiServices {
  final Dio _dio = Dio();

  Stream<ResponseOllamaApi> sendUserMessage({
    required RequestOllamaApi requestApi,
  }) async* {
    final response = await _dio.post(
      ConstApi.baseUrl,

      options: Options(
        headers: {"Content-Type": "application/json"},
        responseType: ResponseType.stream,
      ),

      data: requestApi.toJson(),
    );
    final lineByline = response.data.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (String line in lineByline) {
      if (line.trim().isNotEmpty) {
        yield ResponseOllamaApi.fromJson(jsonDecode(line));
      }
    }
  }
}
