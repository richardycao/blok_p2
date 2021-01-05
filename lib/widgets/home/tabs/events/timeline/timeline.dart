import 'package:blok_p2/main.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Timeline extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    final userData = user.when(
        data: (data) => data, loading: () => null, error: (e, s) => null);

    return userData == null
        ? Loading(blank: true)
        : Container(
            child: SfCalendar(
              view: CalendarView.schedule,
              scheduleViewSettings: ScheduleViewSettings(
                appointmentItemHeight: 70,
                hideEmptyScheduleWeek: true,
                weekHeaderSettings: null,
              ),
            ),
          );
  }
}
