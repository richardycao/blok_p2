import 'package:blok_p2/widgets/home/tabs/events/calendar/event_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/events/events_page.dart';
import 'package:flutter/material.dart';
import 'package:blok_p2/utilities/utilities.dart';
import 'package:flutter_riverpod/all.dart';

class CalendarListTile extends ConsumerWidget {
  String calendarId;
  String name;
  CalendarListTile(this.calendarId, this.name);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final eventState = watch(eventStateProvider);

    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: ListTile(
        leading: Icon(CharIcon().char(name[0]), size: 50.0),
        title: Text(
          name,
          style: TextStyle(fontSize: 20.0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: 50.0,
                child: FlatButton(onPressed: () {}, child: Icon(Icons.share))),
          ],
        ),
        onTap: () {
          eventState.setActiveCalendarId(calendarId);
          Navigator.pushNamed(context, EventCalendar.route);
        },
      ),
    );
  }
}
