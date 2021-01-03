import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/models/user.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/home/home.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/calendar/organization_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationsPage extends StatefulWidget {
  @override
  _OrganizationsPageState createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final HomeState homeState = Provider.of<HomeState>(context);

    String activeCalendarId = homeState.getActiveCalendarId();
    if (activeCalendarId == '' && user != null) {
      if (user.ownedCalendars.isNotEmpty) {
        activeCalendarId =
            user.ownedCalendars.entries.map((e) => e.key).toList()[0];
      }
    }

    return MultiProvider(
        providers: [
          StreamProvider<Calendar>.value(
            value: DatabaseService().streamCalendar(activeCalendarId),
          ),
        ],
        builder: (context, child) {
          final Calendar calendar = Provider.of<Calendar>(context);

          return Scaffold(
            drawer: OrganizationsDrawer(),
            appBar: AppBar(
              title: Text(calendar != null ? calendar.name : ""),
              actions: [
                FlatButton(onPressed: () {}, child: Icon(Icons.more_horiz))
              ],
            ),
            body: OrganizationCalendar(),
          );
        });
  }
}
