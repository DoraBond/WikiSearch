import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wiki_search/network/network_response.dart';

typedef T MappingFun<T>(Map<String, dynamic> json);

class NetworkService {
  final _dio = Dio();
  final BASE_URL = 'https://en.wikipedia.org/';
  
  Future<NetworkResponse> getSearchList() async{
    return _get('w/api.php');
  }

  Future<NetworkResponse> _get<T>(String endpoint,
      {MappingFun<T> mappingFun, Map<String, dynamic> query}) async {
    Response response = await _dio.get(endpoint, queryParameters: query);

    if (response.statusCode != 200) {
      return NetworkResponse(errorCode: response.statusCode);
    } else {
      Map body;
      try {
        body = response.data;
        return NetworkResponse(
            data: mappingFun == null ? response.data : mappingFun(body));
      } catch (e) {
        return NetworkResponse();
      }
    }
  }
}
