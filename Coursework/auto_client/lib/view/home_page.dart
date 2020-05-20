import 'package:autoclient/view/component/screen/route_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:autoclient/model/journal_data.dart';
import 'package:autoclient/model/user.dart';
import 'package:autoclient/model/route.dart' as r;
import 'package:autoclient/model/journal_record.dart';
import 'package:autoclient/model/driver.dart';
import 'package:autoclient/model/automobile.dart';

import 'package:autoclient/service/auto_service.dart';

import 'package:autoclient/view/component/cell/automobile_cell.dart';
import 'package:autoclient/view/component/cell/driver_cell.dart';
import 'package:autoclient/view/component/cell/error_cell.dart';
import 'package:autoclient/view/component/cell/journal_cell.dart';
import 'package:autoclient/view/component/cell/loading_cell.dart';
import 'package:autoclient/view/component/cell/route_cell.dart';

import 'package:autoclient/view/component/screen/details_screen.dart';
import 'package:autoclient/view/component/dialog/error_dialog.dart';

import 'package:autoclient/view/util/home_page_stage.dart';

class HomePage extends StatefulWidget {

  final User user;
  final BaseService service;

  HomePage(this.user, this.service);

  @override
  State createState() => _HomePageStage();

}

class _HomePageStage extends State<HomePage> {

  var _currStage = HomePageStage.NOT_DETERMINED;

  @override
  Widget build(BuildContext context) {
    if (_currStage == HomePageStage.NOT_DETERMINED) {
      return FutureBuilder(
        future: widget.service.refresh(widget.user),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(
              child: CircularProgressIndicator(),
            );
            default:
              if (snapshot.hasError) {
                return ErrorCell('Error: ${snapshot.error}');
              } else {
                _currStage = HomePageStage.JOURNAL;
                return build(context);
              }
          }
        },
      );
    }
    return Scaffold(
      appBar: _makeAppBar(_currStage),
      body: _makeBody(_currStage),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text(
                  'Welcome back, ${widget.user.username}!',
                  style: TextStyle(
                    fontFamily: "Open Sans",
                    fontSize: 20,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
            )
          ] + [
            HomePageStage.JOURNAL,
            HomePageStage.ROUTES,
            HomePageStage.AUTOMOBILES,
            HomePageStage.PERSONNEL
          ].map((stage) {
            return ListTile(
              title: Text(stage.toPrettyString()),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currStage = stage;
                });
              },
            );
          }).toList()
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: _onPressedAdd,
      ),
    );
  }



  void _onPressedAdd() {
    switch (_currStage) {
      case HomePageStage.JOURNAL:
        // TODO: Handle this case.
        break;
      case HomePageStage.ROUTES:
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RouteInput(
                onCancel: () { Navigator.of(context).pop(); },
                onSubmit: (r.Route newRoute) {
                  widget.service.postNew(widget.user, newRoute).then((success) {
                    Navigator.of(context).pop();
                    if (!success) {
                      somethingWentWrong(context);
                    }
                  });
                },
              ),
            )
        );
        break;
      case HomePageStage.AUTOMOBILES:
        // TODO: Handle this case.
        break;
      case HomePageStage.PERSONNEL:
        // TODO: Handle this case.
        break;
      default:
    }
  }

  Widget _makeAppBar(HomePageStage stage) => AppBar(
    title: Text(
      stage.toPrettyString()
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          widget.service.refresh(widget.user).then((value) {
            setState(() {});
          });
        },
      )
    ],
  );

  Widget _makeBody(HomePageStage stage) {
    switch (stage) {
      case HomePageStage.JOURNAL:
        return _makeJournalPage();
      case HomePageStage.ROUTES:
        return _makeRoutesPage();
      case HomePageStage.AUTOMOBILES:
        return _makeAutomobilesPage();
      case HomePageStage.PERSONNEL:
        return _makePersonnelPage();
      default:
        return null;
    }
  }

  Widget _makeRoutesPage() => _buildPage(
    () => widget.service.getRoutes(),
    () => widget.service.loadMoreRoutes(widget.user),
    (r.Route route) => RouteCell(
      route: route,
      details: (r) => DetailsScreen(
        title: route.name,
        header: r,
        onSelect: (String action) => _selectionHandler(
          action,
          route.journalRecords.isEmpty,
          'routes/${route.id}'
        ),
        dataProvider: _getJournalCards(route.journalRecords),
      ),
    )
  );

  Widget _makeJournalPage() => _buildPage(
    () => widget.service.getJournal(),
    () => widget.service.loadMoreJournal(widget.user),
    (JournalRecord journal) {
      return FutureBuilder(
        future: widget.service.getJournalData(widget.user, journal),
        builder: (BuildContext context, AsyncSnapshot<JournalData> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return LoadingCell();
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
                    onSelect: (String action) => _selectionHandler(
                      action,
                      true,
                      'journal/${journal.id}'
                    ),
                    dataProvider: Stream<List<Widget>>.empty(),
                  ),
                );
          }
        },
      );
    }
  );

  Widget _makePersonnelPage() => _buildPage(
    () => widget.service.getPersonnel(),
    () => widget.service.loadMorePersonnel(widget.user),
    (Driver driver) => DriverCell(
      driver: driver,
      details: (d) => DetailsScreen(
        title: '${driver.firstName} ${driver.lastName}',
        header: d,
        onSelect: (String action) => _selectionHandler(
          action,
          driver.automobiles.isEmpty,
          'personnel/${driver.id}'
        ),
        dataProvider: widget.service.getAutomobilesByIds(
          widget.user,
          driver.automobiles
        ).map((List<Automobile> as) =>
            as.map((a) =>
                _makeAutomobileCell(a, driver)).toList())
      ),
    )
  );

  Widget _makeAutomobilesPage() => _buildPage(
    () => widget.service.getAutomobiles(),
    () => widget.service.loadMoreAutomobiles(widget.user),
    (Automobile automobile) {
      return FutureBuilder(
        future: widget.service.getDriverById(widget.user, automobile.driverId),
        builder: (BuildContext context, AsyncSnapshot<Driver> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return LoadingCell();
            default:
              if (snapshot.hasError)
                return ErrorCell('Error: ${snapshot.error}');
              else
                return _makeAutomobileCell(automobile, snapshot.data);
          }
        },
      );
    }
  );

  Widget _buildPage<T>(
    List<T> Function() dataProvider,
    Future<int> Function() onUpdate,
    Widget Function(T) cellBuilder
  ) => ListView.builder(
    itemCount: dataProvider().length,
    itemBuilder: (_, int row) {
      if (row == dataProvider().length - 1) {
        onUpdate().then((int value) {
          if (value != 0) {
            setState(() {});
          }
        });
      }
      return cellBuilder(dataProvider()[row]);
    },
  );
  
  Stream<List<Widget>> _getJournalCards(List<int> jIds) async* {
    var widgets = <Widget>[];
    for (final jId in jIds) {
      final j = await widget.service.getJournalById(widget.user, jId);
      final r = await widget.service.getRouteById(widget.user, j.routeId);
      final a = await widget.service.getAutomobileById(widget.user, j.automobileId);
      final d = await widget.service.getDriverById(widget.user, a.driverId);
      widgets.add(JournalCell(
        journalRecord: j,
        automobile: a,
        route: r,
        driver: d,
        details: (journal) => DetailsScreen(
          title: 'Journal record',
          header: journal,
          onSelect: (String action) => _selectionHandler(
            action,
            true,
            'journal/${j.id}'
          ),
          dataProvider: Stream<List<Widget>>.empty(),
        ),
      ));
      yield widgets;
    }
  }

  Widget _makeAutomobileCell(
    Automobile automobile,
    Driver driver
  ) => AutomobileCell(
    automobile: automobile,
    driver: driver,
    details: (header) => DetailsScreen(
      title: '${automobile.color} ${automobile.mark}',
      header: header,
      onSelect: (String action) => _selectionHandler(
        action,
        automobile.journalRecords.isEmpty,
        'automobiles/${automobile.id}'
      ),
      dataProvider: _getJournalCards(automobile.journalRecords),
    )
  );

  void _delete(String url) {
    widget.service.delete(widget.user, url).then((success) {
      if (success) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        widget.service.refresh(widget.user).then((value) {
          setState(() {});
        });
      } else {
        somethingWentWrong(context);
      }
    });
  }

  void _selectionHandler(String action, bool canBeDeleted, String deletionUrl) {
    switch (action) {
      case 'delete':
        if (canBeDeleted) {
          _delete(deletionUrl);
        } else {
          showDependenciesError(context);
        }
        break;
      default:
        somethingWentWrong(context);
    }
  }

}
