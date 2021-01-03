import 'package:blok_p2/widgets/home/tabs/events/calendar/events_calendar.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: [FlatButton(onPressed: () {}, child: Icon(Icons.menu))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: EventsCalendar(),
    );
  }
}
