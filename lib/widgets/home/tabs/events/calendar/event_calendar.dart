import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/models/time_slot.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/tabs/events/events_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final eventTimeSlotsProvider = StreamProvider<TimeSlots>((ref) {
  final eventCalendar = ref.watch(eventCalendarProvider);
  final eventCalendarData = eventCalendar.when(
      data: (data) => data, loading: () => null, error: (e, s) {});
  return DatabaseService().streamTimeSlots(CalendarType.ORGANIZATION,
      calendarId: eventCalendarData.calendarId);
});

class EventCalendar extends ConsumerWidget {
  static const route = '/event/calendar';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    final userData =
        user.when(data: (data) => data, loading: () => null, error: (e, s) {});
    final eventState = watch(eventStateProvider);
    final calendar = watch(eventCalendarProvider);
    final calendarData = calendar.when(
        data: (data) => data, loading: () => null, error: (e, s) {});
    final timeSlots = watch(eventTimeSlotsProvider);
    final timeSlotsData = timeSlots.when(
        data: (data) => data, loading: () => null, error: (e, s) {});

    DateTime now = DateTime.now();

    void showRequestPanel(CalendarTapDetails details) {
      DateTime dt = details.appointments == null
          ? details.date
          : details.appointments[0].from;
      String timeSlotId = calendarData.constructTimeSlotId(dt);
      if (timeSlotsData.timeSlots[timeSlotId].status != 0) {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 500.0,
                child: Column(
                  children: [
                    Text(dt.toString()),
                    Text(
                        "Occupants: ${timeSlotsData.timeSlots[timeSlotId].occupants.length} / ${timeSlotsData.timeSlots[timeSlotId].limit}"),
                    ElevatedButton(
                        child: timeSlotsData.timeSlots[timeSlotId].occupants
                                .containsKey(userData.userId)
                            ? Text('Leave')
                            : Text('Request a booking'),
                        onPressed: () async {
                          if (timeSlotsData.timeSlots[timeSlotId].occupants
                              .containsKey(userData.userId)) {
                            // if the user is already an occupant
                            await DatabaseService().removeOccupantFromTimeSlot(
                                userData.userId,
                                calendarData.calendarId,
                                timeSlotId);
                          } else {
                            // if the user is not yet an occupant and the time slot is not full
                            await DatabaseService().createJoinTimeSlotRequest(
                                userData,
                                calendarData,
                                timeSlotsData.timeSlots[timeSlotId]);
                          }
                          Navigator.pop(context);
                        }),
                  ],
                ),
              );
            });
      }
    }

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
          child: userData != null &&
                  calendarData != null &&
                  timeSlotsData != null
              ? SfCalendar(
                  minDate: calendarData.createDate.add(Duration(days: 0)),
                  maxDate: DateTime(now.year, now.month, now.day).add(Duration(
                      days: calendar != null
                          ? calendarData.forwardVisibility
                          : 0)),
                  specialRegions: timeSlotsData.timeSlots.entries
                      .map((e) => TimeRegion(
                            startTime: e.value.from,
                            endTime: e.value.from.add(
                                Duration(minutes: calendarData.granularity)),
                            enablePointerInteraction: true,
                            color: e.value.status != 0
                                ? Colors.white
                                : Colors.grey.withOpacity(0.7),
                            text: '',
                          ))
                      .toList(),
                  onTap: (CalendarTapDetails details) {
                    showRequestPanel(details);
                  },
                  view: eventState.calendarView,
                  timeSlotViewSettings: TimeSlotViewSettings(
                      timeInterval: Duration(minutes: calendarData.granularity),
                      timeIntervalHeight: 70,
                      startHour: 0,
                      endHour: 24),
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.transparent),
                    shape: BoxShape.rectangle,
                  ),
                  cellBorderColor: Colors.black54,
                )
              : Text(''),
        ));
  }
}
