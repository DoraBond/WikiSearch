import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wiki_search/theme.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController controller;
  final String initialText;

  SearchInput({this.controller, this.initialText});

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  void initState() {
    widget.controller?.text = widget.initialText ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        isDense: true,
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.inputBorderColor, width: 2),
              borderRadius: BorderRadius.circular(4)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.inputBorderColor, width: 2),
              borderRadius: BorderRadius.circular(4))),
    );
  }
}
