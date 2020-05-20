import 'package:autoclient/model/automobile.dart';
import 'package:autoclient/model/deletable.dart';
import 'package:autoclient/model/driver.dart';
import 'package:autoclient/model/journal_data.dart';
import 'package:autoclient/model/journal_record.dart';
import 'package:autoclient/model/postable.dart';
import 'package:autoclient/model/user.dart';
import 'package:autoclient/service/auto_service.dart';
import 'package:autoclient/view/component/cell/automobile_cell.dart';
import 'package:autoclient/view/component/cell/driver_cell.dart';
import 'package:autoclient/view/component/cell/error_cell.dart';
import 'package:autoclient/view/component/cell/journal_cell.dart';
import 'package:autoclient/view/component/cell/loading_cell.dart';
import 'package:autoclient/view/component/cell/route_cell.dart';
import 'package:autoclient/view/component/screen/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:autoclient/model/route.dart' as r;

class MainPagePresenter {

  final BaseService service;
  final User user;

  MainPagePresenter({
    this.service,
    this.user
  });

  Stream<List<Widget>> getJournalCards(
      List<int> jIds, void Function(bool, Deleteble) onDelete
  ) async* {
    var widgets = <Widget>[];
    for (final jId in jIds) {
      final j = await service.getJournalById(user, jId);
      final r = await service.getRouteById(user, j.routeId);
      final a = await service.getAutomobileById(user, j.automobileId);
      final d = await service.getDriverById(user, a.driverId);
      widgets.add(JournalCell(
        journalRecord: j,
        automobile: a,
        route: r,
        driver: d,
        details: (journal) => DetailsScreen(
          title: 'Journal record',
          header: journal,
          onSelect: (_) => onDelete(true, j),
          dataProvider: Stream<List<Widget>>.empty(),
        ),
      ));
      yield widgets;
    }
  }

  Widget makeAutomobileCell(
    Automobile automobile,
    void Function(bool, Deleteble) onDelete
  ) => FutureBuilder(
    future: service.getDriverById(user, automobile.driverId),
    builder: (BuildContext context, AsyncSnapshot<Driver> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return LoadingCell();
        default:
          if (snapshot.hasError)
            return ErrorCell('Error: ${snapshot.error}');
          else
            return _makeAutomobileCell(automobile, snapshot.data, onDelete);
      }
    },
  );

  Widget _makeAutomobileCell(
    Automobile automobile,
    Driver driver,
    void Function(bool, Deleteble) onDelete
  ) => AutomobileCell(
    automobile: automobile,
    driver: driver,
    details: (header) => DetailsScreen(
      title: '${automobile.color} ${automobile.mark}',
      header: header,
      onSelect: (_) => onDelete(automobile.journalRecords.isEmpty, automobile),
      dataProvider: getJournalCards(automobile.journalRecords, onDelete),
    )
  );

  Widget makeJournalCell(
    JournalRecord journal,
    void Function(bool, Deleteble) onDelete
  ) => FutureBuilder(
    future: service.getJournalData(user, journal),
    builder: (BuildContext context, AsyncSnapshot<JournalData> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return LoadingCell();
        default:
          if (snapshot.hasError)
            return ErrorCell('Error: ${snapshot.error}');
          else
            return JournalCell(
              journalRecord: journal,
              route: snapshot.data.route,
              automobile: snapshot.data.automobile,
              driver: snapshot.data.driver,
              details: (header) => DetailsScreen(
                title: 'Journal record',
                header: header,
                onSelect: (_) => onDelete(true, journal),
                dataProvider: Stream<List<Widget>>.empty(),
              ),
            );
      }
    }
  );

  Widget makeRouteCell(
    r.Route route,
    void Function(bool, Deleteble) onDelete
  ) => RouteCell(
    route: route,
    details: (r) => DetailsScreen(
      title: route.name,
      header: r,
      onSelect: (_) => onDelete(route.journalRecords.isEmpty, route),
      dataProvider: getJournalCards(route.journalRecords, onDelete),
    ),
  );

  Widget makeDriverCell(
    Driver driver,
    void Function(bool, Deleteble) onDelete
  ) => DriverCell(
    driver: driver,
    details: (d) => DetailsScreen(
      title: '${driver.firstName} ${driver.lastName}',
      header: d,
      onSelect: (_) => onDelete(driver.automobiles.isEmpty, driver),
      dataProvider: service.getAutomobilesByIds(user, driver.automobiles)
          .map((List<Automobile> as) => as
          .map((a) => _makeAutomobileCell(a, driver, onDelete)).toList())
    ),
  );

  Future<bool> delete(Deleteble deleteble) => service.delete(user, deleteble);
  Future<bool> post(Postable postable) => service.postNew(user, postable);
  Future<void> refresh() => service.refresh(user);

  List<JournalRecord> getJournal()     => service.getJournal();
  List<Automobile>    getAutomobiles() => service.getAutomobiles();
  List<Driver>        getPersonnel()   => service.getPersonnel();
  List<r.Route>       getRoutes()      => service.getRoutes();

  Future<int> loadMoreJournal()     => service.loadMoreJournal(user);
  Future<int> loadMoreAutomobiles() => service.loadMoreAutomobiles(user);
  Future<int> loadMorePersonnel()   => service.loadMorePersonnel(user);
  Future<int> loadMoreRoutes()      => service.loadMoreRoutes(user);

}
