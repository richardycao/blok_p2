import 'package:blok_p2/main.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_followers/organization_follower_tile.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class OrganizationFollowers extends ConsumerWidget {
  static const route = '/organization/followers';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final calendar =
        watch(organizationCalendarProvider); // this provider is out of scope
    final calendarData = calendar.when(
        data: (data) => data, loading: () => null, error: (e, s) {});

    List<String> followerIds =
        calendarData.followers.entries.map((e) => e.key).toList();
    List<String> followerNames =
        calendarData.followers.entries.map((e) => e.value).toList();

    return calendarData == null
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Followers'),
            ),
            body: ListView.builder(
                itemCount: followerIds.length,
                itemBuilder: (context, index) {
                  return OrganizationFollowerTile(
                    followerId: followerIds[index],
                    followerName: followerNames[index],
                  );
                }),
          );
  }
}
