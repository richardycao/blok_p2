import 'package:blok_p2/main.dart';
import 'package:blok_p2/models/request.dart';
import 'package:blok_p2/models/time_slot.dart';
import 'package:blok_p2/services/database.dart';
import 'package:blok_p2/widgets/common/loading.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/drawer/organization_overview/organization_requests/organization_request_tile.dart';
import 'package:blok_p2/widgets/home/tabs/organizations/organizations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final organizationRequestsProvider = StreamProvider<Requests>((ref) {
  final user = ref.watch(userProvider);
  final calendar = ref.watch(organizationCalendarProvider);
  final userData =
      user.when(data: (data) => data, loading: () => null, error: (e, s) {});
  final calendarData = calendar.when(
      data: (data) => data, loading: () => null, error: (e, s) {});

  if (userData != null) {
    return DatabaseService().streamRequests(userData.incomingRequests.entries
        .where((element) =>
            TimeSlot().extractCalendarId(element.value) ==
            calendarData.calendarId)
        .map((e) => e.key)
        .toList());
  } else {
    return null;
  }
});

class OrganizationRequests extends ConsumerWidget {
  static const route = '/organization/requests';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final requests = watch(organizationRequestsProvider);
    final requestsData = requests.when(
        data: (data) => data, loading: () => null, error: (e, s) {});

    List<String> requestIds = requestsData != null
        ? requestsData.requests.entries.map((e) => e.key).toList()
        : [];
    List<Request> requestObjects = requestsData != null
        ? requestsData.requests.entries.map((e) => e.value).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: ListView.builder(
          itemCount: requestIds.length,
          itemBuilder: (context, index) {
            return OrganizationRequestTile(
              requestId: requestIds[index],
              request: requestObjects[index],
            );
          }),
    );
  }
}
