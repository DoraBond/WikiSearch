import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:wiki_search/data/database/respository_provider.dart';

class SearchResult extends Equatable {
  final List<SearchResultItem> items;
  final bool continueSearch;

  SearchResult(this.items, this.continueSearch);

  @override
  List<Object> get props => [items, continueSearch];
}

class SearchResultItem extends Equatable {
  String title;
  List<String> descriptions;
  String thumbnail;
  num pageid;

  SearchResultItem();

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem()
      ..pageid = json.containsKey('pageid') ? json['pageid'] : null
      ..title = json.containsKey('title') ? json['title'] : null
      ..descriptions = json.containsKey('terms') &&
              (json['terms'] as Map).containsKey('description') &&
              json['terms']['description'] != null
          ? (json['terms']['description'] as List)
              .map((e) => e.toString())
              .toList()
          : []
      ..thumbnail =
          json.containsKey('thumbnail') ? json['thumbnail']['source'] : null;
  }

  factory SearchResultItem.fromRepoMap(Map row) {
    return SearchResultItem()
      ..pageid = row[RepoProvider.REQUESTS_RESULTS_PAGEID]
      ..title = row[RepoProvider.REQUESTS_RESULTS_TITLE]
      ..descriptions = row[RepoProvider.REQUESTS_RESULTS_DESCRIPTIONS] != null
          ? (json.decode(row[RepoProvider.REQUESTS_RESULTS_DESCRIPTIONS]) as List).map((e) => e.toString()).toList()
          : []
      ..thumbnail = row[RepoProvider.REQUESTS_RESULTS_THUMBNAIL];
  }

  Map<String,dynamic> toRepoMap(num requestId) {
    return {
      RepoProvider.REQUESTS_RESULTS_PAGEID: pageid,
      RepoProvider.REQUESTS_RESULTS_DESCRIPTIONS:
          descriptions != null ? json.encode(descriptions) : null,
      RepoProvider.REQUESTS_RESULTS_REQUEST_ID: requestId,
      RepoProvider.REQUESTS_RESULTS_THUMBNAIL: thumbnail,
      RepoProvider.REQUESTS_RESULTS_TITLE: title
    };
  }

  @override
  List<Object> get props => [];
}
