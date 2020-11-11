import 'package:equatable/equatable.dart';

abstract class ListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchDataListEvent extends ListEvent {
  final String search;

  SearchDataListEvent(this.search);

  @override
  List<Object> get props => [search];
}

class LaunchItemListEvent extends ListEvent{
  final num pageid;

  LaunchItemListEvent(this.pageid);

  @override
  List<Object> get props => [pageid];
}
