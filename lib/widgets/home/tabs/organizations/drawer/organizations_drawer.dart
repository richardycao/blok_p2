import 'package:blok_p2/widgets/home/home.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_overview.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_list/organizations_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationsDrawer extends StatelessWidget {
  //static const route = '/organization';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Row(
        children: [
          OrganizationsList(),
          VerticalDivider(color: Colors.black),
          OrganizationOverview()
        ],
      ),
    );
  }
}
