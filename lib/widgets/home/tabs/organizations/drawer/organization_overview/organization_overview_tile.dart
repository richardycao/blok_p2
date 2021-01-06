import 'package:flutter/material.dart';

class OrganizationOverviewTile extends StatelessWidget {
  String title;
  String route;
  OrganizationOverviewTile({this.title, this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: ListTile(
          title: Text(title),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
        ));
  }
}
