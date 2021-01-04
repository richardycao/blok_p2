import 'package:blok_p2/main.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/home.dart';
import 'package:blok_p2/widgets/quick_start/quick_start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class AuthWrapper extends ConsumerWidget {
  static const route = '/';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final firebaseUser = watch(firebaseUserProvider);

    return firebaseUser.when(
        data: (data) => data == null ? QuickStart() : Home(),
        loading: () => Loading(),
        error: (e, s) => Text(e.toString()));
  }
}
