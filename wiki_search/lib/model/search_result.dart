import 'package:equatable/equatable.dart';

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

  @override
  List<Object> get props => [];
}
