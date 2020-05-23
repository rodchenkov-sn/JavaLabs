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
import 'package:autoclient/view/component/screen/automobile_input.dart';
import 'package:autoclient/view/component/screen/details_screen.dart';
import 'package:autoclient/view/component/screen/driver_input.dart';
import 'package:autoclient/view/component/screen/dynamic_table.dart';
import 'package:autoclient/view/component/screen/journal_input.dart';
import 'package:autoclient/view/component/screen/route_input.dart';
import 'package:autoclient/view/util/home_page_stage.dart';
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
      List<int> jIds, void Function(bool, Deleteble) onDelete,
      BuildContext context
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
        onTap: (journal) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailsScreen(
              title: 'Journal record',
              header: journal,
              onSelect: (_) => onDelete(true, j),
              dataProvider: Stream<List<Widget>>.empty(),
            )
          )
        ),
      ));
      yield widgets;
    }
  }

  Widget makeAutomobileCell(
    Automobile automobile, void Function(bool, Deleteble) onDelete,
    BuildContext context, { void Function(Widget) onTap }
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
            return onTap == null ? _makeAutomobileCell(
                automobile, snapshot.data, onDelete, context
            ) : _makeAutomobileCell(
                automobile, snapshot.data, onDelete, context, onTap: onTap
            );
      }
    },
  );

  Widget _makeAutomobileCell(
    Automobile automobile, Driver driver, void Function(bool, Deleteble) onDelete,
    BuildContext context, { void Function(Widget) onTap }
  ) => AutomobileCell(
    automobile: automobile,
    driver: driver,
    onTap: onTap != null ? onTap : (header) => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => DetailsScreen(
          title: '${automobile.color} ${automobile.mark}',
          header: header,
          onSelect: (_) => onDelete(automobile.journalRecords.isEmpty, automobile),
          dataProvider: getJournalCards(automobile.journalRecords, onDelete, ctx),
        )
      )
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
              onTap: (header) => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => DetailsScreen(
                    title: 'Journal record',
                    header: header,
                    onSelect: (_) => onDelete(true, journal),
                    dataProvider: Stream<List<Widget>>.empty(),
                  ),
                )
              )
            );
      }
    }
  );

  Widget makeRouteCell(
    r.Route route, void Function(bool, Deleteble) onDelete, BuildContext context
  ) => RouteCell(
    route: route,
    onTap: (r) => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => DetailsScreen(
          title: route.name,
          header: r,
          onSelect: (_) => onDelete(route.journalRecords.isEmpty, route),
          dataProvider: getJournalCards(route.journalRecords, onDelete, ctx),
        ),
      )
    )
  );

  Widget makeDriverCell(
    Driver driver, void Function(bool, Deleteble) onDelete, BuildContext context
  ) => DriverCell(
    driver: driver,
    onTap: (d) => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>  DetailsScreen(
          title: '${driver.firstName} ${driver.lastName}',
          header: d,
          onSelect: (_) => onDelete(driver.automobiles.isEmpty, driver),
          dataProvider: service.getAutomobilesByIds(user, driver.automobiles)
            .map((List<Automobile> as) => as.map(
                  (a) => _makeAutomobileCell(a, driver, onDelete, ctx)).toList())
        ),
      )
    )
  );

  void showInsertPage(
    HomePageStage stage,
    BuildContext context,
    void Function(Postable) onPost
  ) {
    switch (stage) {
      case HomePageStage.JOURNAL:
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (ctx) => JournalInput(
                  onSubmit: onPost,
                  pickAutomobile: (void Function(Automobile) callback) {
                    Navigator.of(ctx).push(
                        MaterialPageRoute(
                            builder: (ctx) => Scaffold(
                              appBar: AppBar(title: Text('Pick Automobile')),
                              body: DynamicTable<Automobile>(
                                dataProvider: getAutomobiles,
                                onUpdate: loadMoreAutomobiles,
                                cellBuilder: (automobile) =>
                                  makeAutomobileCell(
                                    automobile,
                                    (_, __) {},
                                    ctx,
                                    onTap: (_) {
                                      Navigator.of(ctx).pop();
                                      callback(automobile);
                                    }
                                  )
                              )
                            )
                        )
                    );
                  },
                  pickRoute: (void Function(r.Route) callback) {
                    Navigator.of(ctx).push(
                        MaterialPageRoute(
                            builder: (ctx) => Scaffold(
                                appBar: AppBar(title: Text('Pick route')),
                                body: DynamicTable<r.Route>(
                                    dataProvider: getRoutes,
                                    onUpdate: loadMoreRoutes,
                                    cellBuilder: (route) => RouteCell(
                                      route: route,
                                      onTap: (_) {
                                        Navigator.of(ctx).pop();
                                        callback(route);
                                      },
                                    )
                                )
                            )
                        )
                    );
                  },
                )
            )
        );
        break;
      case HomePageStage.ROUTES:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => RouteInput(
              onSubmit: onPost,
            )
          )
        );
        break;
      case HomePageStage.AUTOMOBILES:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AutomobileInput(
              onSubmit: onPost,
              pickDriver: (void Function(Driver) callback) {
                Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (ctx) => Scaffold(
                      appBar: AppBar(title: Text('Pick driver')),
                      body: DynamicTable<Driver>(
                        dataProvider: getPersonnel,
                        onUpdate: loadMorePersonnel,
                        cellBuilder: (Driver driver) => DriverCell(
                          driver: driver,
                          onTap: (_) {
                            Navigator.of(ctx).pop();
                            callback(driver);
                          },
                        ),
                      )
                    )
                  )
                );
              },
            )
          )
        );
        break;
      case HomePageStage.PERSONNEL:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => DriverInput(
              onSubmit: onPost,
            )
          )
        );
        break;
      default:
    }
  }

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

  String get username => user.username;

}
