import 'package:flutter/material.dart';

class OrganizationsListTile extends StatelessWidget {
  final IconData iconData;
  OrganizationsListTile({this.iconData});

  final double boxWidth = 90.0;
  final double boxHeight = 110.0;
  final double iconSize = 80.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: Column(
          children: [
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Icon(iconData, size: iconSize),
            ),
            Text('org name'),
          ],
        ));
  }
}
