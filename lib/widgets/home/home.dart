import 'package:blok_p2/models/user.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/tabs/tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Tabs tabs = Tabs();

  @override
  Widget build(BuildContext context) {
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: DatabaseService().streamUser(firebaseUser.uid),
        ),
        ChangeNotifierProvider<HomeState>(
          create: (context) => HomeState(),
        ),
      ],
      builder: (context, child) {
        final User user = Provider.of<User>(context);
        final HomeState homeState = Provider.of<HomeState>(context);

        bool serverEnabled = user != null ? user.serverEnabled : false;

        return tabs.item(homeState.getTabIndex(), serverEnabled) == null
            ? Loading
            : Scaffold(
                body: tabs.item(homeState.getTabIndex(), serverEnabled).page,
                bottomNavigationBar: BottomNavigationBar(
                  onTap: homeState.setTabIndex,
                  currentIndex: homeState.getTabIndex(),
                  items: tabs.navItems(serverEnabled),
                ),
              );
      },
    );
  }
}

class HomeState with ChangeNotifier {
  int _tabIndex = 0;
  bool _serverEnabled = false;
  String _activeCalendarId = '';

  getTabIndex() => _tabIndex;
  getServerEnabled() => _serverEnabled;
  getActiveCalendarId() => _activeCalendarId;

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void setServerEnabled(bool isEnabled) {
    _serverEnabled = isEnabled;
    _tabIndex += isEnabled ? 1 : -1;
    notifyListeners();
  }

  void setActiveCalendarId(String id) {
    _activeCalendarId = id;
    notifyListeners();
  }
}
