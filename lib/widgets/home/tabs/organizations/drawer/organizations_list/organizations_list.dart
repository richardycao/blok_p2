import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/user.dart';
import 'package:blok_p2/widgets/home/home.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_list/create_organization/create_organization.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_list/organizations_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class OrganizationsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);

    List<String> orgIds = user.when(
        data: (data) => data.ownedCalendars.entries.map((e) => e.key).toList(),
        loading: () => [],
        error: (e, s) {});

    List<String> orgNames = user.when(
        data: (data) =>
            data.ownedCalendars.entries.map((e) => e.value).toList(),
        loading: () => [],
        error: (e, s) {});

    return Expanded(
      flex: 1,
      child: SizedBox(
          height: 1000,
          child: ListView.builder(
              itemCount: orgIds.length + 1,
              itemBuilder: (context, index) {
                return index < orgIds.length
                    ? OrganizationsListTile(
                        organizationId: orgIds[index],
                        organizationName: orgNames[index],
                        iconData: Icons.account_box,
                      )
                    : FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, CreateOrganization.route);
                          // MaterialPageRoute(
                          //     builder: (context) => CreateOrganization()));
                        },
                        child: Icon(Icons.add, size: 50.0),
                      );
              })),
    );
  }
}
