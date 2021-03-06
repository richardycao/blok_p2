import 'package:blok_p2/models/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlot {
  final String timeSlotId;
  String eventName;
  int status; // make this into a String later for better interpretability
  Map<String, String> occupants; // userId : name
  int limit;
  DateTime from;
  DateTime to;
  Map<String, String> requests; // requestId : userId

  // Ignore these
  Color background;
  bool isAllDay;

  TimeSlot({
    this.timeSlotId,
    this.eventName,
    this.status,
    this.occupants,
    this.limit,
    this.from,
    this.to,
    this.requests,
    this.background,
    this.isAllDay,
  });

  factory TimeSlot.fromSnapshot(DocumentSnapshot snapshot) {
    snapshot = snapshot ?? {};
    return TimeSlot(
      timeSlotId: snapshot.documentID,
      eventName:
          "", //snapshot.data['eventName'] as String ?? snapshot.documentID,
      status: snapshot.data['status'] as int ?? null,
      occupants: Map<String, String>.from(snapshot.data['occupants']) ?? {},
      limit: snapshot.data['limit'] as int ?? null,
      from: snapshot.data['from'].toDate() as DateTime ?? null,
      to: snapshot.data['to'].toDate() as DateTime ?? null,
      requests: Map<String, String>.from(snapshot.data['requests']) ?? {},
      background: Colors.transparent,
      isAllDay: snapshot.data['isAllDay'] ?? false,
    );
  }

  String extractCalendarId(String tsId) {
    return tsId.split("-")[0];
  }
}

class TimeSlots extends CalendarDataSource {
  Map<String, TimeSlot> timeSlots;

  TimeSlots({Map<String, TimeSlot> timeSlots}) {
    appointments =
        timeSlots != null ? timeSlots.entries.map((e) => e.value).toList() : [];
    this.timeSlots = timeSlots ?? {};
  }

  factory TimeSlots.fromDocumentSnapshots(
      List<DocumentSnapshot> snapshots, CalendarType type) {
    snapshots = snapshots ?? {};
    return TimeSlots(
        timeSlots: Map.fromIterable(
      snapshots,
      key: (snap) => snap.documentID,
      value: (snap) {
        return TimeSlot.fromSnapshot(snap);
      },
    ));
  }

  factory TimeSlots.fromQuerySnapshot(
      QuerySnapshot querySnapshot, CalendarType type) {
    List<DocumentSnapshot> snapshots = querySnapshot.documents.toList();
    return TimeSlots.fromDocumentSnapshots(snapshots, type);
  }

  factory TimeSlots.fromDocumentChanges(
      List<DocumentChange> documentChanges, CalendarType type) {
    List<DocumentSnapshot> snapshots =
        documentChanges.map((dc) => dc.document).toList();
    return TimeSlots.fromDocumentSnapshots(snapshots, type);
  }

  // update this.appointments with the document changes
  Map<String, TimeSlot> updateTimeSlots(TimeSlots ts) {
    ts.timeSlots.entries.forEach((element) {
      // rewrites each TimeSlot with new TimeSlot object (element.value)
      timeSlots[element.key] = element.value;

      // for each updated time slot, find it in the appointments list and update
      int index = appointments.firstWhere(
          (listElement) => listElement.timeSlotId == element.key,
          orElse: () => null);

      if (index != null) {
        appointments[index] = element.value;
      } else {
        appointments.add(element.value);
      }
    });
    return timeSlots;
    //appointments = timeSlots.entries.map((e) => e.value).toList();
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}
