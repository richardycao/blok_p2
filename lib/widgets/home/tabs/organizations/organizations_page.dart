import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/calendar/organization_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final organizationStateProvider =
    ChangeNotifierProvider<OrganizationState>((ref) {
  return OrganizationState();
});

final organizationCalendarIdProvider =
    StateNotifierProvider<OrganizationCalendarId>((ref) {
  final user = ref.watch(userProvider);
  final organizationState = ref.watch(organizationStateProvider);
  final userData = user.when(
      data: (data) => data, loading: () => null, error: (e, s) => null);

  if (userData == null) {
    return OrganizationCalendarId();
  } else if (organizationState.activeCalendarId == '' &&
      userData.ownedCalendars.isNotEmpty) {
    return OrganizationCalendarId(
        id: userData.ownedCalendars.entries.map((e) => e.key).toList()[0]);
  }
  return OrganizationCalendarId(id: organizationState.activeCalendarId);
});

final calendarProvider = StreamProvider<Calendar>((ref) {
  final organizationState = ref.watch(organizationCalendarIdProvider.state);
  return DatabaseService().streamCalendar(organizationState);
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

// This is the actual "state". It records all of the data.
class OrganizationState extends ChangeNotifier {
  String _activeCalendarId = '';

  String get activeCalendarId => _activeCalendarId;

  void setActiveCalendarId(String id) {
    _activeCalendarId = id;
    notifyListeners();
  }
}

// This is not the state, despite being a StateNotifier. It only exists to
// propogate the state to the calendarProvider so that can update.
// It's okay to create a brand new OrganizationCalendarId object each time the
// state is updated because this is not visible to any widgets. It's only visible
// to the calendarProvider.
class OrganizationCalendarId extends StateNotifier<String> {
  OrganizationCalendarId({String id}) : super(id ?? '');
}
