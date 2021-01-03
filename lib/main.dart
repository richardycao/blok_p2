import 'package:blok_p2/services/auth.dart';
import 'package:blok_p2/widgets/auth_wrapper.dart';
import 'package:blok_p2/widgets/authenticate/authenticate.dart';
import 'package:blok_p2/widgets/authenticate/convert/convert.dart';
import 'package:blok_p2/widgets/authenticate/register/register.dart';
import 'package:blok_p2/widgets/authenticate/sign_in/sign_in.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_drawer.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_list/create_organization/create_organization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = {
    AuthWrapper.route: (context) => AuthWrapper(),
    Authenticate.route: (context) => Authenticate(
          register: false,
        ),
    Register.route: (context) => Authenticate(
          register: true,
        ),
    SignIn.route: (context) => Authenticate(
          register: false,
        ),
    Convert.route: (context) => Convert(),
    //OrganizationsDrawer.route: (context) => OrganizationsDrawer(),
    //CreateOrganization.route: (context) => CreateOrganization(),
  };

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/',
        routes: routes,
        onGenerateRoute: (rs) {
          print(rs.name);
        },
      ),
    );
  }
}
