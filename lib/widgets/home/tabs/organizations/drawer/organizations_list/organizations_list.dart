import 'package:blok_p2/models/user.dart';
import 'package:blok_p2/widgets/home/home.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_list/create_organization/create_organization.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_list/organizations_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final HomeState homeState = Provider.of<HomeState>(context);

    List<String> orgIds =
        user.ownedCalendars.entries.map((e) => e.key).toList();
    List<String> orgNames =
        user.ownedCalendars.entries.map((e) => e.value).toList();
    print("2 active id: ${homeState.getActiveCalendarId()}");

    return Expanded(
      flex: 1,
      child: SizedBox(
          height: 1000,
          child: ListView.builder(
              itemCount: user.ownedCalendars.length + 1,
              itemBuilder: (context, index) {
                return index < user.ownedCalendars.length
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
