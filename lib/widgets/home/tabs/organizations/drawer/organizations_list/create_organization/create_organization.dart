import 'package:blok_p2/main.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class CreateOrganization extends ConsumerWidget {
  static const route = '/organization/create';
  final _formKey = GlobalKey<FormState>();
  String organizationName = '';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    final organizationState = watch(organizationStateProvider);
    final userData =
        user.when(data: (data) => data, loading: () => null, error: (e, s) {});

    return userData == null
        ? Loading(blank: true)
        : Scaffold(
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
                  validator: (val) =>
                      val.isEmpty ? "Name cannot be empty" : null,
                  onChanged: (val) {
                    organizationName = val;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    dynamic result = await DatabaseService()
                        .createCalendar(userData.userId, organizationName);
                    if (result != null) {
                      organizationState.setActiveCalendarId(result.toString());
                      organizationName = '';
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    }
                  },
                  child: Text('Generate calendar'),
                ),
              ],
            ));
  }
}
