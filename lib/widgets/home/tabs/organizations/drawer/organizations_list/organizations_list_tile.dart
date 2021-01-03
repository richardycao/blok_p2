import 'package:blok_p2/widgets/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationsListTile extends StatelessWidget {
  final organizationId;
  final organizationName;
  final IconData iconData;
  OrganizationsListTile(
      {this.organizationId, this.organizationName, this.iconData});

  final double boxWidth = 90.0;
  final double boxHeight = 110.0;
  final double iconSize = 80.0;

  String truncateWithEllipsis(int cutoff, String str) {
    return (str.length <= cutoff) ? str : '${str.substring(0, cutoff)}...';
  }

  @override
  Widget build(BuildContext context) {
    HomeState homeState = Provider.of<HomeState>(context);

    return SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: Column(
          children: [
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                homeState.setActiveCalendarId(organizationId);
                Navigator.pop(context);
              },
              child: Icon(iconData, size: iconSize),
            ),
            Text(truncateWithEllipsis(9, organizationName)),
          ],
        ));
  }
}
