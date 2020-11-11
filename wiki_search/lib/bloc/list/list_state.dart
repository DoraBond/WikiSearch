import 'package:equatable/equatable.dart';
import 'package:wiki_search/model/search_result.dart';

abstract class ListState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialListState extends ListState {}

class LoadingListState extends ListState {}

class DataLoadErrorListState extends ListState {
  final int code;

  DataLoadErrorListState({this.code});

  @override
  List<Object> get props => [code];
}

class DataLoadedListState extends ListState {
  final List<SearchResultItem> results;
  final resultsCount;
  final searchData;
  final bool continueSearch;

  DataLoadedListState(this.results, this.resultsCount, this.searchData,this.continueSearch);

  @override
  List<Object> get props => [results, continueSearch, resultsCount, searchData];
}
