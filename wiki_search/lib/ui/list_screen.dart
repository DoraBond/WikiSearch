import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_search/bloc/list/list_bloc.dart';
import 'package:wiki_search/bloc/list/list_event.dart';
import 'package:wiki_search/bloc/list/list_state.dart';
import 'package:wiki_search/model/search_result.dart';
import 'package:wiki_search/theme.dart';
import 'package:wiki_search/ui/widget/error_view.dart';
import 'package:wiki_search/ui/widget/loading_view.dart';
import 'package:wiki_search/ui/widget/search_result_widget.dart';
import 'package:wiki_search/ui/widget/search_widget.dart';
import 'package:wiki_search/utils/localization.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer _searchTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _searchTimer?.cancel();
      _searchTimer = Timer(Duration(milliseconds: 500), searchData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).appTitle),
        backgroundColor: AppColors.primaryColor,
      ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
            SearchInput(controller: _controller,),
            BlocBuilder<ListBloc, ListState>(
              builder: (context, state) {
                if (state is LoadingListState) return LoadingView();
                if (state is DataLoadErrorListState)
                  return ErrorView(code: state.code);
                if (state is DataLoadedListState) {
                  return _getSearchResultWidget(state.results);
                }
                return SizedBox.shrink();
              },
            )
          ]),
        ));
  }

  Widget _getSearchResultWidget(List<SearchResultItem> results) {
    return ListView.separated(
        itemCount: results.length,
        itemBuilder: (context, position) =>
            SearchResultWidget(results[position]),
        separatorBuilder: (context, position) => SizedBox(height: 10));
  }

  void searchData() {
    if (_controller.text.length > 2)
      BlocProvider.of<ListBloc>(context)
          .add(SearchDataListEvent(_controller.text));
  }
}
