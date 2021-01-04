import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/home.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/calendar/organization_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

// if (HomeState().getActiveCalendarId() == '' &&
//     user.when(
//         data: (data) => data.ownedCalendars.isNotEmpty,
//         loading: () => false,
//         error: (e, s) => false)) {
//   HomeState().setActiveCalendarId(user.when(
//       data: (data) =>
//           data.ownedCalendars.entries.map((e) => e.key).toList()[0],
//       loading: () => HomeState().getActiveCalendarId(),
//       error: (e, s) {}));
// }

final organizationStateProvider =
    ChangeNotifierProvider<OrganizationState>((ref) {
  final user = ref.read(userProvider);
  final userData = user.when(
      data: (data) => data, loading: () => null, error: (e, s) => null);
  if (userData == null) {
    return OrganizationState();
  } else if (OrganizationState().activeCalendarId == '' &&
      userData.ownedCalendars.isNotEmpty) {
    return OrganizationState(
        calendarId:
            userData.ownedCalendars.entries.map((e) => e.key).toList()[0]);
  }
  return OrganizationState();
});

// final calendarProvider = StreamProvider<Calendar>((ref) {
//   final homeState = ref.read(homeStateProvider);
//   return DatabaseService().streamCalendar(homeState.getActiveCalendarId());
// });

class OrganizationsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final organizationState = watch(organizationStateProvider);
    //final calendar = watch(calendarProvider);
    // print(calendar.when(
    //     data: (data) => data.calendarId,
    //     loading: () => 'loading calendarId',
    //     error: (e, s) => 'error'));
    // final calendarData =
    //     calendar.when(data: (data) => data, loading: () {}, error: (e, s) {});
    print(organizationState);

    return Scaffold(
      drawer: OrganizationsDrawer(),
      appBar: AppBar(
        title: Text(organizationState
            .activeCalendarId), // Text(calendarData != null ? calendarData.name : "-"),
        actions: [FlatButton(onPressed: () {}, child: Icon(Icons.more_horiz))],
      ),
      body: Text('calendar'), //OrganizationCalendar(),
    );
  }
}

class OrganizationState extends ChangeNotifier {
  String _activeCalendarId = '';

  OrganizationState({String calendarId}) {
    _activeCalendarId = calendarId;
  }

  String get activeCalendarId => _activeCalendarId;

  void setActiveCalendarId(String id) {
    _activeCalendarId = id;
    notifyListeners();
  }
}
