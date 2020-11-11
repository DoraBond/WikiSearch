import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_search/bloc/list/list_event.dart';
import 'package:wiki_search/bloc/list/list_state.dart';
import 'package:wiki_search/model/search_result.dart';
import 'package:wiki_search/network/network.dart';
import 'package:wiki_search/network/network_response.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final NetworkService _networkService;

  ListBloc(ListState initialState, this._networkService) : super(initialState);

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is SearchDataListEvent) {
      yield LoadingListState();
      ListState newState = await _loadData(event.search).catchError(onError);
      yield newState ?? DataLoadedListState([]);
    }
  }

  Future<ListState> _loadData(String search) async {
    NetworkResponse<List<SearchResult>> response =
        await _networkService.getSearchList();

    if (response.errorCode != null || response.data == null)
      return DataLoadErrorListState(code: response.errorCode);

    return DataLoadedListState(response.data);
  }
}
