import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Container(
          margin: EdgeInsets.all(8), child: CircularProgressIndicator()));
}
