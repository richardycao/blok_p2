import 'package:blok_p2/widgets/home/tabs/events/events_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventCalendar extends ConsumerWidget {
  static const route = '/event/calendar';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final eventState = watch(eventStateProvider);
    final calendar = watch(eventCalendarProvider);
    final calendarData =
        calendar.when(data: (data) => data, loading: () {}, error: (e, s) {});

    return Scaffold(
        appBar: AppBar(
          title: Text(calendarData != null ? calendarData.name : ''),
          actions: [
            PopupMenuButton(
                elevation: 0,
                onSelected: (value) {
                  eventState.setCalendarView(value);
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
        body: Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
          child: calendarData != null
              ? SfCalendar(
                  view: eventState.calendarView,
                  timeSlotViewSettings: TimeSlotViewSettings(
                      timeInterval: Duration(minutes: calendarData.granularity),
                      timeIntervalHeight: 60,
                      startHour: 0,
                      endHour: 24),
                  selectionDecoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(color: Colors.transparent),
                    //borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  cellBorderColor: Colors.black54,
                )
              : Text(''),
        ));
  }
}
