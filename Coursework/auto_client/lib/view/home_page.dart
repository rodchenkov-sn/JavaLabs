import 'package:autoclient/model/user.dart';
import 'package:autoclient/service/auto_service.dart';
import 'package:autoclient/view/component/cell/automobile_cell.dart';
import 'package:autoclient/view/component/cell/driver_cell.dart';
import 'package:autoclient/view/component/cell/error_cell.dart';
import 'package:autoclient/view/component/cell/journal_cell.dart';
import 'package:autoclient/view/component/cell/loading_cell.dart';
import 'package:autoclient/view/component/cell/route_cell.dart';
import 'package:autoclient/view/component/details/details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:autoclient/model/route.dart' as r;
import 'package:autoclient/model/journal_record.dart';
import 'package:autoclient/model/driver.dart';
import 'package:autoclient/model/automobile.dart';

enum HomePageStage {
  JOURNAL,
  ROUTES,
  AUTOMOBILES,
  PERSONNEL,
  NOT_DETERMINED
}

extension on HomePageStage {
  String toPrettyString() {
    switch (this) {
      case HomePageStage.JOURNAL:
        return 'Journal';
      case HomePageStage.ROUTES:
        return 'Routes';
      case HomePageStage.AUTOMOBILES:
        return 'Automobiles';
      case HomePageStage.PERSONNEL:
        return 'Personnel';
      default:
        return 'Unknown';
    }
  }
}

class _JournalData {
  Automobile automobile;
  Driver driver;
  r.Route route;
}

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
        onPressed: () {},
      ),
    );
  }

  Widget _makeAppBar(HomePageStage stage) {
    return AppBar(
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
  }

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

  Widget _makeRoutesPage() {
    return _buildPage(
      () => widget.service.getRoutes(),
      () => widget.service.loadMoreRoutes(widget.user),
      (r.Route route) => RouteCell(
        route: route,
        details: (r) => DetailsScreen(
          title: route.name,
          header: r,
          onSelect: (String action) {
            switch (action) {
              case 'delete':
                if (route.journalRecords.isNotEmpty) {
                  _showDependenciesError();
                } else {
                  _delete('routes/${route.id}');
                }
                break;
              default:
                print('WIP');
            }
          },
          dataProvider: _getJournalCards(route.journalRecords),
        ),
      )
    );
  }

  Future<_JournalData> _getJournalData(JournalRecord jr) async {
    var jd = _JournalData();
    jd.automobile = await widget.service.getAutomobileById(widget.user, jr.automobileId);
    jd.driver = await widget.service.getDriverById(widget.user, jd.automobile.id);
    jd.route = await widget.service.getRouteById(widget.user, jr.routeId);
    return jd;
  }

  Widget _makeJournalPage() {
    return _buildPage(
      () => widget.service.getJournal(),
      () => widget.service.loadMoreJournal(widget.user),
      (JournalRecord journal) {
        return FutureBuilder(
          future: _getJournalData(journal),
          builder: (BuildContext context, AsyncSnapshot<_JournalData> snapshot) {
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
                      onSelect: (String action) {
                        switch (action) {
                          case 'delete':
                            _delete('journal/${journal.id}');
                            break;
                          default:
                            print('WIP');
                        }
                      },
                      dataProvider: Stream<List<Widget>>.empty(),
                    ),
                  );
            }
          },
        );
      }
    );
  }

  Widget _makePersonnelPage() {
    return _buildPage(
      () => widget.service.getPersonnel(),
      () => widget.service.loadMorePersonnel(widget.user),
      (Driver driver) => DriverCell(
        driver: driver,
        details: (d) => DetailsScreen(
          title: '${driver.firstName} ${driver.lastName}',
          header: d,
          onSelect: (String action) {
            switch (action) {
              case 'delete':
                if (driver.automobiles.isNotEmpty) {
                  _showDependenciesError();
                } else {
                  _delete('personnel/${driver.id}');
                }
                break;
              default:
                print('WIP');
            }
          },
          dataProvider: widget.service.getAutomobilesByIds(
              widget.user, 
              driver.automobiles
          ).map((List<Automobile> as) =>
              as.map((a) =>
                  _makeAutomobileCell(a, driver)).toList())
        ),
      )
    );
  }

  Widget _makeAutomobilesPage() {
    return _buildPage(
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
  }

  Widget _buildPage<T>(
    List<T> Function() dataProvider,
    Future<int> Function() onUpdate,
    Widget Function(T) cellBuilder
  ) {
    return ListView.builder(
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
  }
  
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
          onSelect: (String action) {
            switch (action) {
              case 'delete':
                _delete('journal/${j.id}');
                break;
              default:
                print('WIP');
            }
          },
          dataProvider: Stream<List<Widget>>.empty(),
        ),
      ));
      yield widgets;
    }
  }

  Widget _makeAutomobileCell(Automobile automobile, Driver driver) {
    return AutomobileCell(
        automobile: automobile,
        driver: driver,
        details: (header) => DetailsScreen(
          title: '${automobile.color} ${automobile.mark}',
          header: header,
          onSelect: (String action) {
            switch (action) {
              case 'delete':
                if (automobile.journalRecords.isNotEmpty) {
                  _showDependenciesError();
                } else {
                  _delete('automobiles/${automobile.id}');
                }
                break;
              default:
                print('WIP');
            }
          },
          dataProvider: _getJournalCards(automobile.journalRecords),
        )
    );
  }

  void _somethingWentWrong() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Something went wrong'),
          actions: <Widget>[
            FlatButton(
              child: Text('Bruh'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  void _showDependenciesError() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Could not delete item'),
          content: Text('There are several item that depends on this one. '
              'Try removing them first.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  void _delete(String url) {
    widget.service.delete(widget.user, url).then((success) {
      if (success) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        widget.service.refresh(widget.user).then((value) {
          setState(() {});
        });
      } else {
        _somethingWentWrong();
      }
    });
  }

}
