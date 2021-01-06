import 'package:flutter/material.dart';

class OrganizationFollowerTile extends StatelessWidget {
  String followerId;
  String followerName;
  OrganizationFollowerTile({this.followerId, this.followerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(followerName),
      ),
    );
  }
}
