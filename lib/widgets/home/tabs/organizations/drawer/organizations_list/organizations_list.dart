import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_list/organizations_list_tile.dart';
import 'package:flutter/material.dart';

class OrganizationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.0,
        ),
        OrganizationsListTile(iconData: Icons.account_box_outlined),
        OrganizationsListTile(iconData: Icons.account_box),
        FlatButton(
          onPressed: () {},
          child: Icon(Icons.add, size: 50.0),
        ),
      ],
    );
  }
}
