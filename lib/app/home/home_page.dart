import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/app/home/account/account_page.dart';
import 'package:flutter_time_tracker/app/home/cupertino_home_scaffold.dart';
import 'package:flutter_time_tracker/app/home/jobs/jobs_page.dart';
import 'package:flutter_time_tracker/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilders: widgetBuilders,
    );
  }

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    _currentTab = tabItem;
    setState(() {});
  }
}
