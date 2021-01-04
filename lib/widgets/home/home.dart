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

    final userData = user.when(
        data: (data) => data, loading: () => null, error: (e, s) => null);
    bool serverEnabled = userData != null ? userData.serverEnabled : false;

    return tabs.item(homeState.tabIndex, serverEnabled) == null
        ? Loading()
        : Scaffold(
            body: tabs.item(homeState.tabIndex, serverEnabled).page,
            bottomNavigationBar: BottomNavigationBar(
              onTap: homeState.setTabIndex,
              currentIndex: homeState.tabIndex,
              items: tabs.navItems(serverEnabled),
            ),
          );
  }
}

class HomeState extends ChangeNotifier {
  int _tabIndex = 0;
  bool _serverEnabled = false;

  int get tabIndex => _tabIndex;
  bool get serverEnabled => _serverEnabled;

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void setServerEnabled(bool isEnabled) {
    _serverEnabled = isEnabled;
    _tabIndex += isEnabled ? 1 : -1;
    notifyListeners();
  }
}
