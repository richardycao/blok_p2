import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/models/time_slot.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/tabs/events/calendar/events_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

// pulls in events changes
final eventChangesProvider = StreamProvider<TimeSlots>((ref) {
  final user = ref.watch(userProvider);
  return DatabaseService().streamTimeSlots(CalendarType.EVENT,
      timeSlotIds: user.when(
          data: (data) => data.bookings.entries.map((e) => e.key).toList(),
          loading: () => null,
          error: (e, s) => null));
});

// applies event changes to local event state
final eventStateProvider = ChangeNotifierProvider<EventState>((ref) {
  final eventChanges = ref.watch(eventChangesProvider);
  final eventChangesData = eventChanges.when(
      data: (data) => data, loading: () => null, error: (e, s) => null);
  return EventState();
});

class EventsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: [
          FlatButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
          FlatButton(onPressed: () {}, child: Icon(Icons.menu))
        ],
      ),
      body: EventsCalendar(),
    );
  }
}

class EventState extends ChangeNotifier {
  String _activeCalendarId = '';
  TimeSlots _timeSlots = TimeSlots();

  String get activeCalendarId => _activeCalendarId;
  TimeSlots get timeSlots => _timeSlots;

  void setActiveCalendarId(String id) {
    _activeCalendarId = id;
    notifyListeners();
  }

  void addTimeSlots(TimeSlots ts) {
    _timeSlots.updateTimeSlots(ts);
    notifyListeners();
  }
}
