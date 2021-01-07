import 'package:blok_p2/models/user.dart';
import 'package:blok_p2/services/auth.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/auth_wrapper.dart';
import 'package:blok_p2/widgets/authenticate/authenticate.dart';
import 'package:blok_p2/widgets/authenticate/convert/convert.dart';
import 'package:blok_p2/widgets/authenticate/register/register.dart';
import 'package:blok_p2/widgets/authenticate/sign_in/sign_in.dart';
import 'package:blok_p2/widgets/home/home.dart';
import 'package:blok_p2/widgets/home/tabs/events/add_calendar/add_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/events/calendar/event_calendar.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_followers/organization_followers.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_requests/organization_requests.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organizations_list/create_organization/create_organization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final firebaseUserProvider = StreamProvider<FirebaseUser>((ref) {
  return AuthService().user;
});

final userProvider = StreamProvider<User>((ref) {
  final firebaseUser = ref.watch(firebaseUserProvider);
  return DatabaseService().streamUser(firebaseUser.when(
      data: (data) => data.uid, loading: () => null, error: (e, s) {}));
});

final homeStateProvider = ChangeNotifierProvider<HomeState>((ref) {
  return HomeState();
});

final isLoadingProvider = StateNotifierProvider<IsLoading>((ref) {
  return IsLoading();
});

class MyApp extends StatelessWidget {
  final routes = {
    AuthWrapper.route: (BuildContext context) => AuthWrapper(),
    Authenticate.route: (BuildContext context) => Authenticate(
          register: false,
        ),
    Register.route: (BuildContext context) => Authenticate(
          register: true,
        ),
    SignIn.route: (BuildContext context) => Authenticate(
          register: false,
        ),
    Convert.route: (BuildContext context) => Convert(),
    CreateOrganization.route: (BuildContext context) => CreateOrganization(),
    OrganizationFollowers.route: (BuildContext context) =>
        OrganizationFollowers(),
    OrganizationRequests.route: (BuildContext context) =>
        OrganizationRequests(),
    AddCalendar.route: (BuildContext context) => AddCalendar(),
    EventCalendar.route: (BuildContext context) => EventCalendar(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: routes,
    );
  }
}

class IsLoading extends StateNotifier<bool> {
  IsLoading() : super(false);

  void setLoading(bool input) {
    state = input;
  }
}
