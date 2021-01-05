import 'package:blok_p2/main.dart';
import 'package:blok_p2/services/auth.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/authenticate/convert/convert.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/tabs/profile/profile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class ProfilePage extends ConsumerWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(userProvider);
    final homeState = watch(homeStateProvider);
    final userData =
        user.when(data: (data) => data, loading: () {}, error: (e, s) {});

    return user == null
        ? Loading(blank: true)
        : Column(
            children: [
              ProfileInfoCard(
                label: 'id:',
                value: Text(userData.userId ?? "n/a"),
              ),
              ProfileInfoCard(
                label: 'name:',
                value: Text(userData.displayName ?? "n/a"),
              ),
              ProfileInfoCard(
                  label: 'email:', value: Text(userData.email ?? "n/a")),
              if (userData.email != '')
                ProfileInfoCard(
                  label: 'client/server',
                  value: Switch(
                      value: userData.serverEnabled,
                      onChanged: (result) async {
                        if (!result) {
                          homeState.setServerEnabled(result);
                          await DatabaseService().updateUser(userData.userId,
                              serverEnabled: result);
                        } else {
                          await DatabaseService().updateUser(userData.userId,
                              serverEnabled: result);
                          homeState.setServerEnabled(result);
                        }
                      }),
                ),
              if (userData.email == '')
                FlatButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, Convert.route);
                    },
                    icon: Icon(Icons.arrow_circle_up),
                    label: Text('Convert to permanent account')),
              if (userData.email != '')
                FlatButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                      homeState.setTabIndex(0);
                    },
                    icon: Icon(Icons.person),
                    label: Text('Logout')),
            ],
          );
  }
}
