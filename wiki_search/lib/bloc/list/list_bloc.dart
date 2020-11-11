import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_search/bloc/list/list_event.dart';
import 'package:wiki_search/bloc/list/list_state.dart';
import 'package:wiki_search/model/search_result.dart';
import 'package:wiki_search/network/network.dart';
import 'package:wiki_search/network/network_response.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final NetworkService _networkService;

  List<SearchResultItem> _results = [];
  int _limit = 10;
  int _offset = 0;
  bool _continueSearch = true;
  String _searchData;

  ListBloc(ListState initialState, this._networkService) : super(initialState);

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is SearchDataListEvent) {
      //yield LoadingListState();
      ListState newState = await _loadData(event.search).catchError(onError);
      yield newState ?? DataLoadedListState([],0, false);
    }
  }

  Future<ListState> _loadData(String search) async {
    if (_searchData != search) {
      _offset = 0;
      _results.clear();
      _searchData = search;
    }
    NetworkResponse<SearchResult> response =
        await _networkService.getSearchList(search, _limit, _offset);

    if (response.errorCode != null || response.data == null)
      return DataLoadErrorListState(code: response.errorCode);

    _results.addAll(response.data.items);
    _offset += _limit;
    _continueSearch = response.data.continueSearch;

    return DataLoadedListState(_results, _results.length, _continueSearch);
  }
}
