import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/models/time_slot.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// pulls in timeline timeslots
final eventTimelineTimeSlotsProvider = StreamProvider<TimeSlots>((ref) {
  final user = ref.watch(userProvider);
  return DatabaseService().streamTimeSlots(CalendarType.EVENT,
      timeSlotIds: user.when(
          data: (data) => data.bookings.entries.map((e) => e.key).toList(),
          loading: () => null,
          error: (e, s) => null));
});

class Timeline extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    final userData = user.when(
        data: (data) => data, loading: () => null, error: (e, s) => null);

    return userData == null
        ? Loading(blank: true)
        : userData.bookings.isEmpty
            ? Text('no upcoming events')
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
