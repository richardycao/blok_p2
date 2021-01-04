import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/calendar/organization_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final organizationStateProvider =
    ChangeNotifierProvider<OrganizationState>((ref) {
  final organizationState = OrganizationState();
  // final user = ref.watch(userProvider);
  // final userData = user.when(
  //     data: (data) => data, loading: () => null, error: (e, s) => null);
  // print(organizationState.activeCalendarId);

  // if (userData == null) {
  //   return organizationState;
  // } else if (organizationState.activeCalendarId == '' &&
  //     userData.ownedCalendars.isNotEmpty) {
  //   organizationState.setActiveCalendarId(
  //       userData.ownedCalendars.entries.map((e) => e.key).toList()[0]);
  // }
  // print(organizationState.activeCalendarId);
  return organizationState;
});

final calendarProvider = StreamProvider<Calendar>((ref) {
  final organizationState = ref.watch(organizationStateProvider);
  return DatabaseService().streamCalendar(organizationState.activeCalendarId);
});

class OrganizationsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final calendar = watch(calendarProvider);
    final calendarData =
        calendar.when(data: (data) => data, loading: () {}, error: (e, s) {});

    return Scaffold(
      drawer: OrganizationsDrawer(),
      appBar: AppBar(
        title: Text(calendarData != null ? calendarData.name : "-"),
        actions: [FlatButton(onPressed: () {}, child: Icon(Icons.more_horiz))],
      ),
      body: OrganizationCalendar(),
    );
  }
}

class OrganizationState extends ChangeNotifier {
  String _activeCalendarId = '';

  String get activeCalendarId => _activeCalendarId;

  void setActiveCalendarId(String id) {
    _activeCalendarId = id;
    notifyListeners();
  }
}
