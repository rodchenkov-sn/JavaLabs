import 'dart:convert';

import 'package:autoclient/model/automobile.dart';
import 'package:autoclient/model/driver.dart';
import 'package:autoclient/model/journal_record.dart';
import 'package:autoclient/model/route.dart';
import 'package:autoclient/model/user.dart';

import 'package:http/http.dart' as http;

abstract class BaseService {

  List<JournalRecord>   getJournal();
  List<Automobile>      getAutomobiles();
  List<Driver>          getPersonnel();
  List<Route>           getRoutes();

  Future<int>           loadMoreJournal(User requester);
  Future<int>           loadMoreAutomobiles(User requester);
  Future<int>           loadMorePersonnel(User requester);
  Future<int>           loadMoreRoutes(User requester);

  Future<JournalRecord> getJournalById(User requester, int id);
  Future<Automobile>    getAutomobileById(User requester, int id);
  Future<Driver>        getDriverById(User requester, int id);
  Future<Route>         getRouteById(User requester, int id);

  Stream<List<JournalRecord>> getJournalByIds(User requester, List<int> ids);
  Stream<List<Automobile>>    getAutomobilesByIds(User requester, List<int> ids);
  Stream<List<Driver>>        getDriversById(User requester, List<int> ids);
  Stream<List<Route>>         getRoutesById(User requester, List<int> ids);

  Future<void> refresh(User requester);
  Future<bool> delete(User requester, String url);

}

class AutoService implements BaseService {

  final baseUrl = 'http://192.168.17.1:8075/autoservice';

  var _journal = <JournalRecord>[];
  var _routes = <Route>[];
  var _personnel = <Driver>[];
  var _automobiles = <Automobile>[];

  var _journalPage = 0;
  var _routesPage = 0;
  var _personnelPage = 0;
  var _automobilesPage = 0;

  @override
  List<Automobile> getAutomobiles() => _automobiles;

  @override
  List<JournalRecord> getJournal() => _journal;

  @override
  List<Driver> getPersonnel() => _personnel;

  @override
  List<Route> getRoutes() => _routes;

  Future<Iterable> _loadMore(String token, String url) async {
    final header = { 'Authorization': 'Bearer_$token' };
    final response = await http.get(url, headers: header);
    return json.decode(response.body);
  }

  @override
  Future<int> loadMoreAutomobiles(User requester) async {
    final newRecords = (await _loadMore(
      requester.token,
      '$baseUrl/automobiles/page/${_automobilesPage++}'
    )).map((a) => Automobile.fromJson(a)).toList();
    _automobiles.addAll(newRecords);
    return newRecords.length;
  }

  @override
  Future<int> loadMoreJournal(User requester) async {
    final newRecords = (await _loadMore(
      requester.token,
      '$baseUrl/journal/page/${_journalPage++}'
    )).map((a) => JournalRecord.fromJson(a)).toList();
    _journal.addAll(newRecords);
    return newRecords.length;
  }

  @override
  Future<int> loadMorePersonnel(User requester) async {
    final newRecords = (await _loadMore(
      requester.token,
      '$baseUrl/personnel/page/${_personnelPage++}'
    )).map((a) => Driver.fromJson(a)).toList();
    _personnel.addAll(newRecords);
    return newRecords.length;
  }

  @override
  Future<int> loadMoreRoutes(User requester) async {
    final newRecords = (await _loadMore(
      requester.token,
      '$baseUrl/routes/page/${_routesPage++}'
    )).map((a) => Route.fromJson(a)).toList();
    _routes.addAll(newRecords);
    return newRecords.length;
  }

  Future<String> _getFromUrl(String token, String url) async {
    final header = { 'Authorization': 'Bearer_$token' };
    final response = await http.get(url, headers: header);
    return response.body;
  }

  @override
  Stream<List<Route>> getRoutesById(User requester, List<int> ids) async* {
    var routes = <Route>[];
    for (final id in ids) {
      routes.add(await getRouteById(requester, id));
      yield routes;
    }
  }

  @override
  Stream<List<Driver>> getDriversById(User requester, List<int> ids) async* {
    var drivers = <Driver>[];
    for (final id in ids) {
      drivers.add(await getDriverById(requester, id));
      yield drivers;
    }
  }

  @override
  Stream<List<Automobile>> getAutomobilesByIds(User requester, List<int> ids) async* {
    var automobiles = <Automobile>[];
    for (final id in ids) {
      automobiles.add(await getAutomobileById(requester, id));
      yield automobiles;
    }
  }

  @override
  Stream<List<JournalRecord>> getJournalByIds(User requester, List<int> ids) async* {
    var journal = <JournalRecord>[];
    for (final id in ids) {
      journal.add(await getJournalById(requester, id));
      yield journal;
    }
  }

  @override
  Future<Driver> getDriverById(User requester, int id) async {
    final d = _personnel.firstWhere((element) => element.id == id);
    return d != null ? d : Driver.fromJson(json.decode(await _getFromUrl(
      requester.token,
      '$baseUrl/personnel/$id'
    )));
  }

  @override
  Future<Route> getRouteById(User requester, int id) async {
    final r = _routes.firstWhere((element) => element.id == id);
    return r != null ? r : Route.fromJson(json.decode(await _getFromUrl(
        requester.token,
        '$baseUrl/routes/$id'
    )));
  }

  @override
  Future<Automobile> getAutomobileById(User requester, int id) async {
    final a = _automobiles.firstWhere((element) => element.id == id);
    return a != null ? a : Automobile.fromJson(json.decode(await _getFromUrl(
        requester.token,
        '$baseUrl/automobiles/$id'
    )));
  }

  @override
  Future<JournalRecord> getJournalById(User requester, int id) async {
    final j = _journal.firstWhere((element) => element.id == id);
    return j != null ? j : JournalRecord.fromJson(json.decode(await _getFromUrl(
        requester.token,
        '$baseUrl/journal/$id'
    )));
  }

  @override
  Future<void> refresh(User requester) async {
    _journal = [];
    _automobiles = [];
    _routes =  [];
    _personnel = [];
    _journalPage = _automobilesPage = _routesPage = _personnelPage = 0;
    await loadMoreJournal(requester);
    await loadMoreAutomobiles(requester);
    await loadMoreRoutes(requester);
    await loadMorePersonnel(requester);
  }

  @override
  Future<bool> delete(User requester, String url) async {
    final header = { 'Authorization': 'Bearer_${requester.token}' };
    final response = (await http.delete('$baseUrl/$url', headers: header)).body;
    print(response);
    return response == 'ok';
  }

}
