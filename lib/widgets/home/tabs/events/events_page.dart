import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/models/time_slot.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/tabs/events/add_calendar/add_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/events/calendar_list/calendar_list.dart';
import 'package:blok_p2/widgets/home/tabs/events/timeline/timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// pulls in events changes
final eventDiffProvider = StreamProvider<TimeSlots>((ref) {
  final user = ref.watch(userProvider);
  return DatabaseService().streamTimeSlots(CalendarType.EVENT,
      timeSlotIds: user.when(
          data: (data) => data.bookings.entries.map((e) => e.key).toList(),
          loading: () => ['1C7aunVONj8fbvBgEPjK-1609480800'],
          error: (e, s) => ['1C7aunVONj8fbvBgEPjK-1609484400']));
});

// grabs local state
final eventStateProvider = ChangeNotifierProvider<EventState>((ref) {
  return EventState();
});

final eventCalendarProvider = StreamProvider<Calendar>((ref) {
  final eventState = ref.watch(eventStateProvider);
  return DatabaseService().streamCalendar(eventState.activeCalendarId);
});

// applies event changes and propogates to visible "state"
final eventTimeSlotsProvider = StateNotifierProvider<EventTimeSlots>((ref) {
  final eventDiff = ref.watch(eventDiffProvider);
  final eventState = ref.watch(eventStateProvider);
  final eventDiffData = eventDiff.when(
      data: (data) => data, loading: () => null, error: (e, s) => null);

  // return objects of the state notifier
  return null;
});

class EventsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    void _showAddPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 115.0,
            child: ListView(
              children: [
                ListTile(
                  title: Text('Scan QR code'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Enter calendar ID'),
                  onTap: () {
                    Navigator.pushNamed(context, AddCalendar.route);
                  },
                ),
              ],
            ),
          );
        },
        elevation: 30.0,
      );
    }

    final eventDiff = watch(eventDiffProvider);
    final eventDiffData = eventDiff.when(
        data: (data) => data, loading: () => null, error: (e, s) => null);
    print(eventDiffData);

    // final eventState = watch(eventStateProvider);
    // print(eventState.timeSlots.timeSlots.entries.map((e) => e.key).toList());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Events'),
          actions: [
            SizedBox(
              width: 60.0,
              child: FlatButton(
                onPressed: () {
                  _showAddPanel();
                },
                child: Icon(Icons.add),
              ),
            ),
            SizedBox(
              width: 60.0,
              child: FlatButton(onPressed: () {}, child: Icon(Icons.menu)),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Timeline'),
              Tab(text: 'Calendars'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Timeline(),
            CalendarList(),
          ],
        ),
      ),
    );
  }
}

// This is the actual "state". It records all of the data.
class EventState extends ChangeNotifier {
  String _activeCalendarId = '';
  CalendarView _calendarView = CalendarView.week;
  TimeSlots _timeSlots = TimeSlots();

  TimeSlots get timeSlots => _timeSlots;
  CalendarView get calendarView => _calendarView;
  String get activeCalendarId => _activeCalendarId;

  void setActiveCalendarId(String id) {
    _activeCalendarId = id;
    notifyListeners();
  }

  void setCalendarView(CalendarView view) {
    _calendarView = view;
    notifyListeners();
  }

  void addTimeSlots(TimeSlots ts) {
    _timeSlots.updateTimeSlots(ts);
    notifyListeners();
  }
}

// This is not the state, despite being a StateNotifier. It only exists to
// propogate the state to ...
class EventTimeSlots extends StateNotifier<TimeSlots> {
  EventTimeSlots({TimeSlots ts}) : super(ts ?? TimeSlots(timeSlots: {}));
}
