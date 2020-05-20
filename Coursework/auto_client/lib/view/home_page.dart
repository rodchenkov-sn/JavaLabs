import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:autoclient/model/route.dart' as r;
import 'package:autoclient/model/journal_record.dart';
import 'package:autoclient/model/driver.dart';
import 'package:autoclient/model/automobile.dart';
import 'package:autoclient/model/deletable.dart';
import 'package:autoclient/model/postable.dart';

import 'package:autoclient/view/component/dialog/error_dialog.dart';

import 'package:autoclient/view/util/home_page_stage.dart';

import 'package:autoclient/presenter/main_page_presenter.dart';

class HomePage extends StatefulWidget {

  final MainPagePresenter presenter;

  HomePage(this.presenter);

  @override
  State createState() => _HomePageStage();

}

class _HomePageStage extends State<HomePage> {

  var _currStage = HomePageStage.NOT_DETERMINED;
  
  @override
  Widget build(BuildContext context) {
    if (_currStage == HomePageStage.NOT_DETERMINED) {
      return FutureBuilder(
        future: widget.presenter.refresh(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(
              child: CircularProgressIndicator(),
            );
            default:
              if (snapshot.hasError) {
                somethingWentWrong(context);
                return build(context);
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
                  'OwO',
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
    
  }

  void _postNew(Postable postable) {
    widget.presenter.post(postable).then((success) {
      if (!success) {
        somethingWentWrong(context);
      } else {
        Navigator.of(context).pop();
        _refresh();
      }
    });
  }

  Widget _makeAppBar(HomePageStage stage) => AppBar(
    title: Text(
      stage.toPrettyString()
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: _refresh
      )
    ],
  );

  void _refresh() {
    widget.presenter.refresh().then((_) {
      setState(() {});
    });
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

  Widget _makeRoutesPage() => _buildPage(
    widget.presenter.getRoutes,
    widget.presenter.loadMoreRoutes,
    (r.Route route) 
      => widget.presenter.makeRouteCell(route, _delete)
  );

  Widget _makeJournalPage() => _buildPage(
    widget.presenter.getJournal,
    widget.presenter.loadMoreJournal,
    (JournalRecord journal) 
      => widget.presenter.makeJournalCell(journal, _delete)
  );

  Widget _makePersonnelPage() => _buildPage(
    widget.presenter.getPersonnel,
    widget.presenter.loadMorePersonnel,
    (Driver driver) 
      => widget.presenter.makeDriverCell(driver, _delete)
  );

  Widget _makeAutomobilesPage() => _buildPage(
    widget.presenter.getAutomobiles,
    widget.presenter.loadMoreAutomobiles,
    (Automobile automobile) 
      => widget.presenter.makeAutomobileCell(automobile, _delete)
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

  void _delete(bool canBeDeleted, Deleteble item) {
    if (canBeDeleted) {
      widget.presenter.delete(item).then((success) {
        if (success) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          widget.presenter.refresh().then((value) {
            setState(() {});
          });
        } else {
          somethingWentWrong(context);
        }
      });
    } else {
      showDependenciesError(context);
    }
  }

}
