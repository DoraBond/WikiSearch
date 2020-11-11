import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wiki_search/model/search_result.dart';
import 'package:wiki_search/theme.dart';

class SearchResultWidget extends StatelessWidget {
  final SearchResultItem searchResult;

  SearchResultWidget(this.searchResult);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 100,
            height: 100,
            child: searchResult.thumbnail != null
                ? CachedNetworkImage(imageUrl: searchResult.thumbnail,fit: BoxFit.cover)
                : Container(color: AppColors.picturePlaceholderColor),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(searchResult.title, softWrap: true),
                  searchResult.descriptions != null &&
                          searchResult.descriptions.isNotEmpty
                      ? Column(
                          children: searchResult.descriptions
                              .map((e) => Text(e, softWrap: true))
                              .toList())
                      : SizedBox.shrink()
                ]),
          )
        ]);
  }
}
