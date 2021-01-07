import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/utilities/utilities.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_followers/organization_followers.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_overview_tile.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_requests/organization_requests.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class OrganizationOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final calendar = watch(organizationCalendarProvider);
    final calendarData =
        calendar.when(data: (data) => data, loading: () {}, error: (e, s) {});

    return Expanded(
      flex: 2,
      child: SizedBox(
        height: 650.0,
        child: Column(
          children: [
            Text(
                truncateWithEllipsis(
                    8, calendarData != null ? calendarData.name : ""),
                style: TextStyle(fontSize: 25.0)),
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                OrganizationOverviewTile(
                  title: 'Followers',
                  route: OrganizationFollowers.route,
                ),
                OrganizationOverviewTile(
                  title: 'Requests',
                  route: OrganizationRequests.route,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
