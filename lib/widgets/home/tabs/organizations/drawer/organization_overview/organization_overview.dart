import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_overview_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Calendar calendar = Provider.of<Calendar>(context);

    return Expanded(
      flex: 2,
      child: SizedBox(
        height: 600.0,
        child: Column(
          children: [
            Text(calendar != null ? calendar.name : '-',
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
