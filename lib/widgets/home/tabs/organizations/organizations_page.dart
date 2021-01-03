import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_drawer.dart';
import 'package:flutter/material.dart';

class OrganizationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: OrganizationsDrawer(),
      appBar: AppBar(
        title: Text('Organizations'),
        actions: [],
      ),
    );
  }
}
