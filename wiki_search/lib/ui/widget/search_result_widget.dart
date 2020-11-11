import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:wiki_search/model/search_result.dart';
import 'package:wiki_search/theme.dart';

class SearchResultWidget extends StatelessWidget {
  final SearchResultItem searchResult;

  SearchResultWidget(this.searchResult);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 100,
        height: 100,
        child: searchResult.thumbnail != null
            ? CachedNetworkImage(imageUrl: searchResult.thumbnail)
            : Container(color: AppColors.picturePlaceholderColor),
      ),
      Column(children: [
        Text(searchResult.title),
        searchResult.descriptions != null &&
                searchResult.descriptions.isNotEmpty
            ? searchResult.descriptions.map((e) => Text(e)).toList()
            : SizedBox.shrink()
      ])
    ]);
  }
}
