import 'package:blok_p2/main.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/tabs/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class Home extends ConsumerWidget {
  final Tabs tabs = Tabs();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    final homeState = watch(homeStateProvider);

    final userData =
        user.when(data: (data) => data, loading: () {}, error: (e, s) {});
    bool serverEnabled = user != null ? userData.serverEnabled : false;

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

    //final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);
    // return MultiProvider(
    //   providers: [
    //     StreamProvider<User>.value(
    //       value: DatabaseService().streamUser(firebaseUser.uid),
    //     ),
    //     ChangeNotifierProxyProvider<User, HomeState>(
    //       create: (context) => HomeState(),
    //       update: (context, user, homeState) {
    //         String activeCalendarId = homeState.getActiveCalendarId();
    //         if (activeCalendarId == '' && user != null) {
    //           if (user.ownedCalendars.isNotEmpty) {
    //             homeState.setActiveCalendarId(
    //                 user.ownedCalendars.entries.map((e) => e.key).toList()[0]);
    //           }
    //         }
    //         return homeState;
    //       },
    //     ),
    //   ],
    //   builder: (context, child) {
    //     final User user = Provider.of<User>(context);
    //     final HomeState homeState = Provider.of<HomeState>(context);

    //     bool serverEnabled = user != null ? user.serverEnabled : false;

    //     return tabs.item(homeState.getTabIndex(), serverEnabled) == null
    //         ? Loading
    //         : Scaffold(
    //             body: tabs.item(homeState.getTabIndex(), serverEnabled).page,
    //             bottomNavigationBar: BottomNavigationBar(
    //               onTap: homeState.setTabIndex,
    //               currentIndex: homeState.getTabIndex(),
    //               items: tabs.navItems(serverEnabled),
    //             ),
    //           );
    //   },
    // );
  }
}

class HomeState extends ChangeNotifier {
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

  HomeState withActiveCalendarId(String id) {
    this.setActiveCalendarId(id);
    return this;
  }
}
