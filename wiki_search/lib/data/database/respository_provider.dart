import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:wiki_search/data/database/requests_repository.dart';

class RepoProvider {
  static const REQUESTS_TABLE_NAME = 'requests';
  static const REQUESTS_SEARCH_STRING = 'search_string';
  static const REQUESTS_RESULTS_TABLE_NAME = 'request_results';
  static const REQUESTS_RESULTS_TITLE = 'title';
  static const REQUESTS_RESULTS_REQUEST_ID = 'request_id';
  static const REQUESTS_RESULTS_PAGEID = 'pageid';
  static const REQUESTS_RESULTS_THUMBNAIL = 'thumbnail';
  static const REQUESTS_RESULTS_DESCRIPTIONS = 'description_json';

  static final _databaseName = "wiki_search.db";
  static final _databaseVersion = 1;
  static Database _database;

  RequestsRepository requestsRepository;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  RepoProvider() {
    requestsRepository = RequestsRepository(database);
  }

  _initDatabase() async {
    Directory documentsDirectory = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getLibraryDirectory();
    String path = p.join(documentsDirectory.toString(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' CREATE TABLE $REQUESTS_TABLE_NAME (
            id INTEGER NOT NULL UNIQUE,
            $REQUESTS_SEARCH_STRING TEXT NOT NULL UNIQUE,
            
            PRIMARY KEY(id)
          );
          ''');

    await db.execute(''' CREATE TABLE $REQUESTS_RESULTS_TABLE_NAME (
            id INTEGER NOT NULL UNIQUE,
            $REQUESTS_RESULTS_REQUEST_ID INTEGER NOT NULL,
            $REQUESTS_RESULTS_PAGEID INTEGER NOT NULL,
            $REQUESTS_RESULTS_TITLE TEXT NOT NULL,
            $REQUESTS_RESULTS_THUMBNAIL TEXT,
            $REQUESTS_RESULTS_DESCRIPTIONS TEXT,
            
            PRIMARY KEY(id)
          );
          ''');
  }
}
