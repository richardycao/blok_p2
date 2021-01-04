import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class OrganizationCalendar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final calendar = watch(calendarProvider);
    final calendarData =
        calendar.when(data: (data) => data, loading: () {}, error: (e, s) {});

    return Container(
      child: calendar != null
          ? SfCalendar(
              view: CalendarView.day,
              timeSlotViewSettings: TimeSlotViewSettings(
                  timeInterval:
                      // calendar != null
                      //     ? Duration(minutes: calendar.granularity)
                      //     :
                      const Duration(minutes: 60),
                  timeIntervalHeight: 60,
                  startHour: 0,
                  endHour: 24),
            )
          : Text(''),
    );
  }
}
