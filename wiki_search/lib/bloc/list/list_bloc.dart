import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiki_search/bloc/list/list_event.dart';
import 'package:wiki_search/bloc/list/list_state.dart';
import 'package:wiki_search/data/database/requests_repository.dart';
import 'package:wiki_search/data/network/network.dart';
import 'package:wiki_search/data/network/network_response.dart';
import 'package:wiki_search/model/search_result.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final NetworkService _networkService;
  final RequestsRepository _requestsRepository;

  List<SearchResultItem> _results = [];
  int _limit = 10;
  int _offset = 0;
  bool _continueSearch = true;
  String _searchData;

  ListBloc(
      ListState initialState, this._networkService, this._requestsRepository)
      : super(initialState);

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is SearchDataListEvent) {
      if (event.search.length < 2)
        yield DataLoadedListState([], 0, event.search, false);
      else {
        ListState newState = await _loadData(event.search).catchError(onError);
        yield newState ?? DataLoadedListState([], 0, event.search, false);
      }
    } else if (event is LaunchItemListEvent) {
      yield await _loadItemUrl(event.pageid);
    }
  }

  Future<ListState> _loadItemUrl(num pageid) async {
    NetworkResponse<String> response =
        await _networkService.getWikiPageUrl(pageid).catchError(onError);

    if (response.errorCode != null || response.data == null)
      return DataLoadErrorListState(code: response.errorCode);

    String wikiUrl = response.data;
    if (wikiUrl != null) launch(wikiUrl);
    return state;
  }

  Future<ListState> _loadData(String search) async {
    if (_searchData != search) {
      _offset = 0;
      _results.clear();
      _searchData = search;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)
      return _offlineLoadSearchResults(search);
    else
      return _onlineLoadSearchResults(search);
  }

  Future<ListState> _offlineLoadSearchResults(String search) async {
    List<SearchResultItem> items =
        await _requestsRepository.getRequests(search);

    return DataLoadedListState(items, items.length, search, false);
  }

  Future<ListState> _onlineLoadSearchResults(String search) async {
    NetworkResponse<SearchResult> response =
        await _networkService.getSearchList(search, _limit, _offset);

    if (response.errorCode != null || response.data == null)
      return DataLoadErrorListState(code: response.errorCode);

    _results.addAll(response.data.items);
    _offset += _limit;
    _continueSearch = response.data.continueSearch;

    _saveToDatabase(search, response.data.items);
    return DataLoadedListState(
        _results, _results.length, _searchData, _continueSearch);
  }

  Future _saveToDatabase(String search, List<SearchResultItem> results) async {
    int requestId = await _requestsRepository.getRequest(search);
    _requestsRepository.insertRequestResults(results, requestId);
  }
}
