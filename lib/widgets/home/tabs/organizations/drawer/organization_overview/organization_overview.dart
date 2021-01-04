import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_overview_tile.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class OrganizationOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final calendar = watch(calendarProvider);
    final calendarData =
        calendar.when(data: (data) => data, loading: () {}, error: (e, s) {});

    return Expanded(
      flex: 2,
      child: SizedBox(
        height: 650.0,
        child: Column(
          children: [
            Text(calendarData != null ? calendarData.name : "-",
                style: TextStyle(fontSize: 25.0)),
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                OrganizationOverviewTile(),
                OrganizationOverviewTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
