import 'package:blok_p2/widgets/home/tabs/events/events_page.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';

class Tabs {
  final bool serverEnabled;
  final Function onServerEnabled;
  List<Tab> _tabs;

  Tabs({this.serverEnabled, this.onServerEnabled}) {
    _tabs = [
      Tab(
        page: OrganizationsPage(),
        icon: Icon(Icons.calendar_today),
        label: 'Organizations',
        serverOnly: true,
      ),
      Tab(
        page: EventsPage(),
        icon: Icon(Icons.event_note),
        label: 'Events',
        serverOnly: false,
      ),
      Tab(
        page: Text('profile'), //Profile(onServerEnabled: onServerEnabled),
        icon: Icon(Icons.person),
        label: 'Profile',
        serverOnly: false,
      ),
    ];
  }

  List<Tab> visibleTabs() {
    if (serverEnabled == false) {
      return _tabs.where((tab) => !tab.serverOnly).toList();
    }
    return _tabs;
  }

  // get data for a single tab
  Tab item(int index) {
    return visibleTabs()[index];
  }

  // get all the navigation bar items for the tabs
  List<BottomNavigationBarItem> navItems() {
    return visibleTabs().map((element) {
      return BottomNavigationBarItem(icon: element.icon, label: element.label);
    }).toList();
  }
}

class Tab {
  final Widget page;
  final Widget icon;
  final String label;
  final bool serverOnly;

  Tab({this.page, this.icon, this.label, this.serverOnly});
}
