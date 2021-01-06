import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class OrganizationCalendar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final organizationState = watch(organizationStateProvider);
    final organizationIsEditing = watch(organizationIsEditingProvider.state);
    final calendar = watch(organizationCalendarProvider);
    final calendarData = calendar.when(
        data: (data) => data, loading: () => null, error: (e, s) {});
    final timeSlots = watch(organizationTimeSlotsProvider);
    final timeSlotsData = timeSlots.when(
        data: (data) => data, loading: () => null, error: (e, s) {});

    DateTime now = DateTime.now();

    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: calendarData != null && timeSlotsData != null
          ? SfCalendar(
              minDate: calendarData.createDate.add(Duration(days: 0)),
              maxDate: DateTime(now.year, now.month, now.day).add(Duration(
                  days: calendar != null ? calendarData.forwardVisibility : 0)),
              specialRegions: timeSlotsData.timeSlots.entries
                  .map((e) => TimeRegion(
                        startTime: e.value.from,
                        endTime: e.value.from
                            .add(Duration(minutes: calendarData.granularity)),
                        enablePointerInteraction: true,
                        color: e.value.status != 0
                            ? Colors.white
                            : Colors.grey.withOpacity(0.7),
                        text: '',
                      ))
                  .toList(),
              onTap: organizationIsEditing
                  ? (CalendarTapDetails details) async {
                      DateTime dt = details.appointments == null
                          ? details.date
                          : details.appointments[0].from;
                      String timeSlotId = calendarData.constructTimeSlotId(dt);
                      int status =
                          timeSlotsData.timeSlots[timeSlotId].status == 0
                              ? 1
                              : 0;
                      await DatabaseService().updateTimeSlot(
                          calendarData.calendarId,
                          timeSlotsData.timeSlots[timeSlotId],
                          status: status);
                    }
                  : null,
              view: organizationState.calendarView,
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
    );
  }
}
