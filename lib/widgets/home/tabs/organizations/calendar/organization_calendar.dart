import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_list/create_organization/create_organization.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class OrganizationCalendar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final organizationState = watch(organizationStateProvider);
    final calendar = watch(organizationCalendarProvider);
    final calendarData =
        calendar.when(data: (data) => data, loading: () {}, error: (e, s) {});

    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
      child: calendarData != null
          ? SfCalendar(
              view: organizationState.calendarView,
              timeSlotViewSettings: TimeSlotViewSettings(
                  timeInterval: Duration(minutes: calendarData.granularity),
                  timeIntervalHeight: 60,
                  startHour: 0,
                  endHour: 24),
              selectionDecoration: BoxDecoration(
                color: Colors.orange[50],
                border: Border.all(color: Colors.transparent),
                //borderRadius: const BorderRadius.all(Radius.circular(4)),
                shape: BoxShape.rectangle,
              ),
              cellBorderColor: Colors.black54,
            )
          : Text(''),
    );
  }
}
