import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/request.dart';
import 'package:blok_p2/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class OrganizationRequestTile extends ConsumerWidget {
  String requestId;
  Request request;
  OrganizationRequestTile({this.requestId, this.request});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    final userData =
        user.when(data: (data) => data, loading: () => null, error: (e, s) {});

    return userData == null
        ? Text('')
        : Container(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                      "${request.requesterName} wants time ${request.from}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 50.0,
                          child: FlatButton(
                              onPressed: () async {
                                await DatabaseService()
                                    .respondJoinTimeSlotRequest(
                                        userData.userId, request, 1);
                              },
                              child: Icon(
                                Icons.check,
                                color: userData != null
                                    ? request.responses[userData.userId] == 1
                                        ? Colors.green
                                        : Colors.black
                                    : Colors.black,
                              ))),
                      SizedBox(
                          width: 50.0,
                          child: FlatButton(
                              onPressed: () async {
                                await DatabaseService()
                                    .respondJoinTimeSlotRequest(
                                        userData.userId, request, 0);
                              },
                              child: Icon(
                                Icons.close,
                                color: userData != null
                                    ? request.responses[userData.userId] == 0
                                        ? Colors.red
                                        : Colors.black
                                    : Colors.black,
                              ))),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: new LinearPercentIndicator(
                    lineHeight: 14.0,
                    percent: ((request.hasOwnerApproval ? 1.0 : 0.0) +
                            (request.hasOtherApproval ? 1.0 : 0.0)) /
                        2.0,
                    center: Text(
                      "${((request.hasOwnerApproval ? 1.0 : 0.0) + (request.hasOtherApproval ? 1.0 : 0.0)).toInt()} / 2",
                      style: new TextStyle(fontSize: 12.0),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                ),
              ],
            ),
          );
  }
}
