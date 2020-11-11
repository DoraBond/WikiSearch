import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wiki_search/bloc/list/list_bloc.dart';
import 'package:wiki_search/bloc/list/list_state.dart';
import 'package:wiki_search/data/database/respository_provider.dart';
import 'package:wiki_search/ui/list_screen.dart';
import 'package:wiki_search/utils/app_routes.dart';
import 'package:wiki_search/utils/localization.dart';

import 'data/network/network.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(WikiSearchApp());
}

class WikiSearchApp extends StatelessWidget {
  final NetworkService _networkService = NetworkService();
  final RepoProvider _repoProvider = RepoProvider();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        localizationsDelegates: [
          AppLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateTitle: (context) => AppLocalization.of(context).appTitle,
        supportedLocales: [Locale('en', '')],
        initialRoute: AppRoute.LIST,
        routes: {
          AppRoute.LIST: (context) => _listScreen(context),
        });
  }

  Widget _listScreen(BuildContext context) {
    return BlocProvider(
      create: (context) => ListBloc(InitialListState(), _networkService,
          _repoProvider.requestsRepository),
      child: ListScreen(),
    );
  }
}
