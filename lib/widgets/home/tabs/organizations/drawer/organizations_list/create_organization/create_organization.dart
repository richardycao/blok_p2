import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrganization extends StatefulWidget {
  static const route = '/organization/create';

  @override
  _CreateOrganizationState createState() => _CreateOrganizationState();
}

class _CreateOrganizationState extends State<CreateOrganization> {
  final _formKey = GlobalKey<FormState>();
  String organizationName = '';

  @override
  Widget build(BuildContext context) {
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);
    //final HomeState homeState = Provider.of<HomeState>(context);

    if (firebaseUser == null) {
      return Loading();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Create Organization'),
        ),
        body: Column(
          key: _formKey,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Organization Name',
              ),
              validator: (val) => val.isEmpty ? "Name cannot be empty" : null,
              onChanged: (val) {
                setState(() => organizationName = val);
              },
            ),
            ElevatedButton(
              onPressed: () async {
                dynamic result = await DatabaseService()
                    .createCalendar(firebaseUser.uid, organizationName);
                if (result != null) {
                  //homeState.setActiveCalendarId(result.toString());
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
              },
              child: Text('Generate calendar'),
            ),
          ],
        ));
  }
}
