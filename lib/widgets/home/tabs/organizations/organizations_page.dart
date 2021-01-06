import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/models/time_slot.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/calendar/organization_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Tracks the state
final organizationStateProvider =
    ChangeNotifierProvider<OrganizationState>((ref) {
  return OrganizationState();
});

// Propogates the calendarId to the organizationCalendarProvider
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

// Streams the active organization calendar
final organizationCalendarProvider = StreamProvider<Calendar>((ref) {
  final organizationState = ref.watch(organizationCalendarIdProvider.state);
  return DatabaseService().streamCalendar(organizationState);
});

// Streams changes in time slots of the active organization calendar
final organizationTimeSlotsProvider = StreamProvider<TimeSlots>((ref) {
  final organizationState = ref.watch(organizationCalendarIdProvider.state);
  return DatabaseService().streamTimeSlots(CalendarType.ORGANIZATION,
      calendarId: organizationState);
});

final organizationIsEditingProvider =
    StateNotifierProvider<OrganizationIsEditing>((ref) {
  return OrganizationIsEditing();
});

class OrganizationsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final organizationState = watch(organizationStateProvider);
    final organizationIsEditing = watch(organizationIsEditingProvider.state);
    final calendar = watch(organizationCalendarProvider);
    final calendarData = calendar.when(
        data: (data) => data, loading: () => null, error: (e, s) {});

    return Scaffold(
      drawer: OrganizationsDrawer(),
      appBar: AppBar(
        title: Text(calendarData != null ? calendarData.name : ""),
        actions: [
          SizedBox(
            width: 50.0,
            child: FlatButton(
                onPressed: () {
                  context
                      .read(organizationIsEditingProvider)
                      .setIsEditing(!organizationIsEditing);
                },
                child: organizationIsEditing
                    ? Icon(
                        Icons.edit_off,
                        size: 25.0,
                      )
                    : Icon(Icons.edit, size: 25.0)),
          ),
          PopupMenuButton(
              elevation: 0,
              onSelected: (value) {
                organizationState.setCalendarView(value);
              },
              itemBuilder: (context) => {
                    'Daily': CalendarView.day,
                    'Weekly': CalendarView.week
                  }
                      .entries
                      .map<PopupMenuItem>((e) =>
                          PopupMenuItem(child: Text(e.key), value: e.value))
                      .toList(),
              icon: Icon(Icons.view_agenda))
        ],
      ),
      body: OrganizationCalendar(),
    );
  }
}

// This is the actual "state". It records all of the data.
class OrganizationState extends ChangeNotifier {
  String _activeCalendarId = '';
  CalendarView _calendarView = CalendarView.week;

  String get activeCalendarId => _activeCalendarId;
  CalendarView get calendarView => _calendarView;

  void setActiveCalendarId(String id) {
    _activeCalendarId = id;
    notifyListeners();
  }

  void setCalendarView(CalendarView view) {
    _calendarView = view;
    notifyListeners();
  }
}

class OrganizationIsEditing extends StateNotifier<bool> {
  OrganizationIsEditing() : super(false);

  void setIsEditing(bool input) {
    state = input;
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

// Also not the state
class OrganizationTimeSlots extends ChangeNotifier {
  TimeSlots _timeSlots = TimeSlots(timeSlots: {});

  TimeSlots get timeSlots => _timeSlots;
}
