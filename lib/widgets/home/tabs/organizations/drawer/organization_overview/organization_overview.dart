import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_overview_tile.dart';
import 'package:flutter/material.dart';

class OrganizationOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 200.0,
        child: Column(
          children: [
            Text('org name'),
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
