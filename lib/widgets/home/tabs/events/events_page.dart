import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/models/time_slot.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/tabs/events/add_calendar/add_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/events/calendar_list/calendar_list.dart';
import 'package:blok_p2/widgets/home/tabs/events/timeline/timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final eventStateProvider = ChangeNotifierProvider<EventState>((ref) {
  return EventState();
});

final eventCalendarProvider = StreamProvider<Calendar>((ref) {
  final eventState = ref.watch(eventStateProvider);
  return DatabaseService().streamCalendar(eventState.activeCalendarId);
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
