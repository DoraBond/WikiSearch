import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wiki_search/model/search_result.dart';

import 'network_response.dart';

typedef T MappingFun<T>(Map<String, dynamic> json);

class NetworkService {
  final _dio = Dio();
  final _BASE_URL = 'https://en.wikipedia.org/';

  Future<NetworkResponse<SearchResult>> getSearchList(
      String search, int limit, int offset) async {
    return await _get('w/api.php', query: {
      "action": "query",
      "formatversion": 2,
      "format": "json",
      "prop": "pageimages|pageterms",
      "generator": "prefixsearch",
      "redirects": 1,
      "piprop": "thumbnail",
      "pithumbsize": "50",
      "pilimit": 10,
      "wbptterms": "description",
      "gpssearch": search,
      "gpslimit": limit,
      "gpsoffset": offset
    }, mappingFun: (json) {
      if (json == null) return null;
      if (!json.containsKey('query') ||
          !(json['query'] as Map).containsKey('pages') ||
          json['query']['pages'] == null) return SearchResult([], false);

      List pages = json['query']['pages'];
      return SearchResult(
          pages.map((e) => SearchResultItem.fromJson(e)).toList(),
          json.containsKey('continue') ? true : false);
    });
  }

  Future<NetworkResponse<String>> getWikiPageUrl(num pageid) async {
    return await _get('w/api.php', query: {
      "action": "query",
      "format": "json",
      "prop": "info",
      "pageids": pageid,
      "inprop": "url"
    }, mappingFun: (json) {
      if (json == null) return null;
      if (!json.containsKey('query') ||
          !(json['query'] as Map).containsKey('pages') ||
          json['query']['pages'] == null) return null;

      Map pages = json['query']['pages'];
      Map page = pages[pageid.toString()];

      return page != null ? page['fullurl'] : null;
    });
  }

  Future<NetworkResponse<T>> _get<T>(String endpoint,
      {MappingFun<T> mappingFun, Map<String, dynamic> query}) async {
    print('START HTTP GET ${_BASE_URL + endpoint}');
    Response response =
        await _dio.get(_BASE_URL + endpoint, queryParameters: query);

    print(response.toString());
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
