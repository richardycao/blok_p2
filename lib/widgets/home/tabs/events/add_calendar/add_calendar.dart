import 'package:blok_p2/main.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class AddCalendar extends ConsumerWidget {
  static const route = '/event/add';
  String calendarId = '';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    final userData =
        user.when(data: (data) => data, loading: () => null, error: (e, s) {});

    return userData == null
        ? Loading(blank: true)
        : Scaffold(
            appBar: AppBar(
              title: Text('Add Calendar'),
            ),
            body: Column(children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Calendar Id',
                ),
                onChanged: (val) {
                  calendarId = val;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  dynamic result = await DatabaseService()
                      .addFollowerToCalendar(userData.userId, calendarId);
                  if (result != null) {
                    calendarId = '';
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  } else {
                    print('error adding calendar');
                  }
                },
                child: Text('Add calendar'),
              ),
            ]));
  }
}
