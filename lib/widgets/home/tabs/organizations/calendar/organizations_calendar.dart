import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class OrganizationsCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: SfCalendar(
        view: CalendarView.day,
        timeSlotViewSettings: TimeSlotViewSettings(
            // move this to calendar settings later
            timeInterval:
                // calendar != null
                //     ? Duration(minutes: calendar.granularity)
                //     :
                const Duration(minutes: 60),
            timeIntervalHeight: 60,
            startHour: 0,
            endHour: 24),
      ),
    );
  }
}
