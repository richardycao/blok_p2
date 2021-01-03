import 'package:blok_p2/models/calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class OrganizationCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Calendar calendar = Provider.of<Calendar>(context);

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
