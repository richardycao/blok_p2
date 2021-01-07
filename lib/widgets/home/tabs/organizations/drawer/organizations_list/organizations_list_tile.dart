import 'package:blok_p2/main.dart';
import 'package:blok_p2/utilities/utilities.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class OrganizationsListTile extends ConsumerWidget {
  final organizationId;
  final organizationName;
  final IconData iconData;
  OrganizationsListTile(
      {this.organizationId, this.organizationName, this.iconData});

  final double boxWidth = 90.0;
  final double boxHeight = 110.0;
  final double iconSize = 70.0;
  final double fontSize = 15.0;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final organizationState = watch(organizationStateProvider);

    return SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: Column(
          children: [
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                organizationState.setActiveCalendarId(organizationId);
                Navigator.pop(context);
              },
              child: Icon(iconData, size: iconSize),
            ),
            Text(
              truncateWithEllipsis(6, organizationName),
              style: TextStyle(fontSize: fontSize),
            ),
          ],
        ));
  }
}
