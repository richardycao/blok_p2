import 'package:cloud_firestore/cloud_firestore.dart';

enum CalendarType { OWNER, CLIENT }

class Calendar {
  final String calendarId;
  String name;
  String description;
  Map<String, String> owners; // userId : name
  Map<String, String> followers; // userId : name
  int backVisibility;
  int forwardVisibility;
  DateTime createDate;
  int granularity; // in minutes
  Map<String, String> requests; // requestId : userId
  bool requiresJoinApproval;
  bool timeSlotRequiresOwnerApproval;

  Calendar({
    this.calendarId,
    this.name,
    this.description,
    this.owners,
    this.followers,
    this.backVisibility,
    this.forwardVisibility,
    this.createDate,
    this.granularity,
    this.requests,
    this.requiresJoinApproval,
    this.timeSlotRequiresOwnerApproval,
  });

  factory Calendar.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null) {
      return Calendar.empty();
    }
    Map data = snapshot.data;
    data = data ?? {};
    return Calendar(
      calendarId: snapshot.documentID ?? null,
      name: data['name'] as String ?? null,
      description: data['description'] as String ?? null,
      owners: Map<String, String>.from(data['owners']) ?? {},
      followers: Map<String, String>.from(data['followers']) ?? {},
      backVisibility: data['backVisibility'] as int ?? null,
      forwardVisibility: data['forwardVisibility'] as int ?? null,
      createDate: data['createDate'].toDate() as DateTime ?? null,
      granularity: data['granularity'] as int ?? null,
      requests: Map<String, String>.from(data['requests']) ?? {},
      requiresJoinApproval: data['requiresJoinApproval'] as bool ?? null,
      timeSlotRequiresOwnerApproval:
          data['timeSlotRequiresOwnerApproval'] as bool ?? null,
    );
  }

  factory Calendar.empty() {
    return Calendar(
        calendarId: null,
        name: '-',
        description: '-',
        owners: {},
        followers: {},
        backVisibility: 0,
        forwardVisibility: 0,
        createDate: null,
        granularity: 60,
        requests: {},
        requiresJoinApproval: true,
        timeSlotRequiresOwnerApproval: true);
  }

  String constructTimeSlotId(DateTime dt) {
    return calendarId + "-" + Timestamp.fromDate(dt).seconds.toString();
  }

  DateTime minDate() {
    return null;
  }

  DateTime maxDate() {
    return null;
  }
}
