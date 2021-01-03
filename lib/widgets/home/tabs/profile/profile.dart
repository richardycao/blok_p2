import 'package:blok_p2/models/user.dart';
import 'package:blok_p2/services/auth.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/authenticate/convert/convert.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/home.dart';
import 'package:blok_p2/widgets/home/tabs/profile/profile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final HomeState homeState = Provider.of<HomeState>(context);

    if (user == null) {
      return Loading(
        blank: true,
      );
    }

    return Column(
      children: [
        ProfileInfoCard(
          label: 'id:',
          value: Text(user.userId ?? "n/a"),
        ),
        ProfileInfoCard(
          label: 'name:',
          value: Text(user.displayName ?? "n/a"),
        ),
        ProfileInfoCard(label: 'email:', value: Text(user.email ?? "n/a")),
        if (user.email != null)
          ProfileInfoCard(
            label: 'client/server',
            value: Switch(
                value: user.serverEnabled,
                onChanged: (result) async {
                  homeState.setServerEnabled(result);
                  await DatabaseService()
                      .updateUser(user.userId, serverEnabled: result);
                }),
          ),
        if (user.email == null)
          FlatButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, Convert.route);
              },
              icon: Icon(Icons.arrow_circle_up),
              label: Text('Convert to permanent account')),
        if (user.email != null)
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('Logout')),
      ],
    );
  }
}
