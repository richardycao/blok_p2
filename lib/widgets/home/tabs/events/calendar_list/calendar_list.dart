import 'package:blok_p2/main.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/tabs/events/calendar_list/calendar_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class CalendarList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    final userData =
        user.when(data: (data) => data, loading: () => null, error: (e, s) {});

    List<String> calendars = userData == null
        ? null
        : userData.followedCalendars.entries.map((e) => e.value).toList();

    return userData == null
        ? Loading(blank: true)
        : ListView.builder(
            itemCount: userData.followedCalendars.length,
            itemBuilder: (context, index) {
              return CalendarListTile(calendars[index]);
            });
  }
}
