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
                  ? CachedNetworkImage(
                      imageUrl: searchResult.thumbnail, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.picturePlaceholderColor,
                      child: Center(
                        child: Icon(Icons.photo,
                        color: Colors.grey,
                        size: 30),
                      ))),
          SizedBox(width: 16),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(searchResult.title,
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  searchResult.descriptions != null &&
                          searchResult.descriptions.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: searchResult.descriptions
                              .map((e) => Text(
                                    e,
                                    softWrap: true,
                                    textAlign: TextAlign.left,
                                  ))
                              .toList())
                      : SizedBox.shrink()
                ]),
          )
        ]);
  }
}
