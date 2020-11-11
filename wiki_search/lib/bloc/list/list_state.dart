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
  final List<SearchResult> results;

  DataLoadedListState(this.results);

  @override
  List<Object> get props => [results];
}
