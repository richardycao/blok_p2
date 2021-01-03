import 'package:blok_p2/widgets/home/home.dart';
import 'package:blok_p2/widgets/quick_start/quick_start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);

    return user == null ? QuickStart() : Home();
  }
}
