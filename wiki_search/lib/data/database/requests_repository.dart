import 'package:sqflite/sqflite.dart';
import 'package:wiki_search/data/database/respository_provider.dart';
import 'package:wiki_search/model/search_result.dart';

class RequestsRepository {
  final Future<Database> _database;

  RequestsRepository(this._database);

  Future<int> insertRequest(String searchData) async {
    final db = await _database;

    int res = await db.insert(
      RepoProvider.REQUESTS_TABLE_NAME,
      {RepoProvider.REQUESTS_SEARCH_STRING: searchData},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return res;
  }

  Future<int> getRequest(String searchData) async {
    final db = await _database;

    List requests = await db.query(RepoProvider.REQUESTS_TABLE_NAME,
        where: '${RepoProvider.REQUESTS_SEARCH_STRING} = ?',
        whereArgs: [searchData]);
    if (requests.isEmpty)
      return insertRequest(searchData);
    else
      return requests[0]['id'];
  }

  Future<List<SearchResultItem>> getRequests(String searchData) async {
    final db = await _database;

    num requestId = await getRequest(searchData);
    if (requestId == null)
      return [];
    else {
      List requests = await db.query(RepoProvider.REQUESTS_RESULTS_TABLE_NAME,
          where: '${RepoProvider.REQUESTS_RESULTS_REQUEST_ID} = ?',
          whereArgs: [requestId]);

      return requests.map((e) => SearchResultItem.fromRepoMap(e)).toList();
    }
  }

  Future insertRequestResults(
      List<SearchResultItem> results, num requestId) async {
    final db = await _database;

    results.forEach((element) {
      db.insert(
        RepoProvider.REQUESTS_RESULTS_TABLE_NAME,
        element.toRepoMap(requestId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future clearData() async {
    final db = await _database;

    db.delete(RepoProvider.REQUESTS_TABLE_NAME);
    db.delete(RepoProvider.REQUESTS_RESULTS_TABLE_NAME);
  }
}
