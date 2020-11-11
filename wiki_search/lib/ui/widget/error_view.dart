import 'package:flutter/widgets.dart';
import 'package:wiki_search/utils/localization.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final int code;

  ErrorView({this.message, this.code});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: EdgeInsets.all(8),
            child: Text(AppLocalization.of(context).httpErrorCode +
                (code?.toString() ?? ''))));
  }
}
