import 'package:blok_p2/constants/testing_constants.dart';
import 'package:blok_p2/models/calendar.dart';
import 'package:blok_p2/models/request.dart';
import 'package:blok_p2/models/time_slot.dart';
import 'package:blok_p2/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static const String USERS = 'users';
  static const String CALENDARS = 'calendars';
  static const String TIMESLOTS = 'timeSlots';
  static const String REQUESTS = 'requests';

  //////////////////////////////////////////////////////////////////////////////////////////////////
  /// STREAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  Stream<User> streamUser(String userId) {
    try {
      return Firestore.instance
          .collection(USERS)
          .document(userId)
          .snapshots()
          .map((snapshot) => User.fromSnapshot(snapshot));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<Calendar> streamCalendar(String calendarId) {
    try {
      return Firestore.instance
          .collection(CALENDARS)
          .document(calendarId)
          .snapshots()
          .map((snapshot) => Calendar.fromSnapshot(snapshot));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<TimeSlots> streamTimeSlots(CalendarType type,
      {String calendarId, List<String> timeSlotIds}) {
    try {
      if (type == CalendarType.ORGANIZATION) {
        return Firestore.instance
            .collection(CALENDARS)
            .document(calendarId)
            .collection(TIMESLOTS)
            .snapshots()
            .map((snapshot) => TimeSlots.fromQuerySnapshot(snapshot, type));
      } else if (type == CalendarType.EVENT) {
        List<String> calendarIds =
            timeSlotIds.map((e) => TimeSlot().extractCalendarId(e)).toList();

        return Firestore.instance
            .collection(CALENDARS)
            .where(FieldPath.documentId, whereIn: calendarIds)
            .getDocuments()
            .asStream()
            .map((snapshot) =>
                TimeSlots.fromDocumentChanges(snapshot.documentChanges, type));
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<Request> streamRequest(String requestId) {
    try {
      return Firestore.instance
          .collection(REQUESTS)
          .document(requestId)
          .snapshots()
          .map((snapshot) => Request.fromSnapshot(snapshot));
    } catch (e) {
      print(e);
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  /// USER
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // CREATE user
  Future createUser(String userId,
      {String username,
      String displayName = anon_name,
      String email = "",
      bool serverEnabled = false}) async {
    await Firestore.instance.collection(USERS).document(userId).setData({
      'displayName': displayName,
      'username': username ?? userId,
      'email': email,
      'ownedCalendars': {},
      'followedCalendars': {},
      'serverEnabled': serverEnabled,
      'bookings': {},
      'incomingRequests': {},
      'outgoingRequests': {},
    });
  }

  // UPDATE user
  Future updateUser(String userId,
      {String displayName, String email, bool serverEnabled}) async {
    await Firestore.instance.collection(USERS).document(userId).setData({
      if (displayName != null) 'displayName': displayName,
      if (email != null) 'email': email,
      if (serverEnabled != null) 'serverEnabled': serverEnabled,
    }, merge: true);
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  /// CALENDAR
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // CREATE calendar
  Future<String> createCalendar(String userId, String calendarName,
      {String description = "",
      int backVisiblity = 0,
      int forwardVisibility = 2,
      int granularity = 60}) async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      DocumentSnapshot userSnapshot =
          await Firestore.instance.collection(USERS).document(userId).get();

      // Creates calendar
      DocumentReference docRef =
          await Firestore.instance.collection(CALENDARS).add({
        'name': calendarName,
        'description': description,
        'owners': {userId: userSnapshot['displayName']},
        'followers': {},
        'backVisibility': backVisiblity,
        'forwardVisibility': forwardVisibility,
        'createDate': now,
        'granularity': granularity,
        'requests': {},
        'requiresJoinApproval': true,
        'timeSlotRequiresOwnerApproval': true,
      });
      String calendarId = docRef.documentID;

      // Add time slots
      DateTime start = today.add(Duration(days: backVisiblity));
      DateTime end = today.add(Duration(days: forwardVisibility));
      final timeDiff = end.difference(start).inHours;
      List<DateTime> timeSlots = List.generate(
          timeDiff,
          (i) => DateTime(
              start.year, start.month, start.day, start.hour + (i), 0, 0));

      CollectionReference timeSlotsCollection = Firestore.instance
          .collection(CALENDARS)
          .document(calendarId)
          .collection(TIMESLOTS);

      timeSlots.forEach((ts) async {
        String timeSlotId =
            Calendar(calendarId: calendarId).constructTimeSlotId(ts);
        // removed await here
        timeSlotsCollection.document(timeSlotId).setData({
          'eventName': null,
          'status': 0,
          'occupants': {},
          'limit': testTimeSlotLimit,
          'from': ts,
          'to': ts.add(Duration(minutes: granularity)),
          'requests': {},
          'background': null,
          'isAllDay': null,
        });
      });

      // Updates user's owned calendars
      // removed await here
      Firestore.instance.collection(USERS).document(userId).updateData({
        "ownedCalendars.$calendarId": calendarName,
      });

      return calendarId;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // ADD user to calendar
  Future addFollowerToCalendar(String userId, String calendarId) async {
    try {
      DocumentSnapshot calendarSnapshot = await Firestore.instance
          .collection(CALENDARS)
          .document(calendarId)
          .get(); // try to remove

      // Adds user to calendar's list of followers
      // removed await here
      Firestore.instance.collection(CALENDARS).document(calendarId).updateData({
        "followers.$userId": temp_name,
      });

      // Updates user's followed calendars
      // removed await here
      Firestore.instance.collection(USERS).document(userId).updateData({
        "followedCalendars.$calendarId":
            calendarSnapshot.data['name'] as String,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // REMOVE follower from calendar
  Future removeFollowerFromCalendar(User user, String calendarId) async {
    try {
      // Remove user from all the calendar's time slots
      List<String> timeSlotIdsToClear = Map<String, String>.from(user.bookings)
          .entries
          .where((element) => element.value == calendarId)
          .map((element) => element.key)
          .toList();
      timeSlotIdsToClear.forEach((tsId) async {
        Map<String, Object> deleteUserId = {};
        deleteUserId["occupants.${user.userId}"] = FieldValue.delete();
        // removed await here
        Firestore.instance
            .collection(CALENDARS)
            .document(calendarId)
            .collection(TIMESLOTS)
            .document(tsId)
            .updateData(deleteUserId);
      });

      // Removes user from calendar's list of followers
      Map<String, Object> deleteFollowerId = {};
      deleteFollowerId["followers.${user.userId}"] = FieldValue.delete();
      // removed await here
      Firestore.instance
          .collection(CALENDARS)
          .document(calendarId)
          .updateData(deleteFollowerId);

      // Updates user's followed calendars and bookings
      Map<String, String> bookings =
          new Map<String, String>.from(user.bookings);
      final Map<String, String> followedCalendars =
          new Map<String, String>.from(user.followedCalendars);
      bookings = Map<String, String>.fromEntries(bookings.entries.where(
          (element) =>
              TimeSlot().extractCalendarId(element.key) != calendarId));
      followedCalendars.remove(calendarId);
      // removed await here
      Firestore.instance.collection(USERS).document(user.userId).setData({
        'bookings': bookings,
        'followedCalendars': followedCalendars,
      }, merge: true);
    } catch (e) {
      print(e.toString());
    }
  }

  // UPDATE calendar
  Future updateCalendar(String calendarId,
      {String name, String description, int granularity}) async {
    // removed await here
    Firestore.instance.collection(CALENDARS).document(calendarId).setData({
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (granularity != null) 'granularity': granularity,
    }, merge: true);
  }

  // DELETE calendar
  Future deleteCalendar() async {}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  /// TIME SLOT
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // ADD occupant to time slot
  Future addOccupantToTimeSlot(
      User user, String calendarId, String timeSlotId) async {
    try {
      // Adds user to time slot's occupants
      // removed await here
      Firestore.instance
          .collection(CALENDARS)
          .document(calendarId)
          .collection(TIMESLOTS)
          .document(timeSlotId)
          .updateData({
        "occupants.$user.userId": user.displayName,
      });

      // Updates user's bookings
      // removed await here
      Firestore.instance.collection(USERS).document(user.userId).updateData({
        "bookings.$timeSlotId": DateTime.now(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // REMOVE occupant from time slot
  Future removeOccupantFromTimeSlot(
      String userId, String calendarId, String timeSlotId) async {
    try {
      // Updates user's bookings
      Map<String, Object> deleteTimeSlotId = {};
      deleteTimeSlotId["bookings.$timeSlotId"] = FieldValue.delete();
      // removed await here
      Firestore.instance
          .collection(USERS)
          .document(userId)
          .updateData(deleteTimeSlotId);

      // Removes user to time slot's occupants
      Map<String, Object> deleteUserId = {};
      deleteUserId["occupants.$userId"] = FieldValue.delete();
      // removed await here
      Firestore.instance
          .collection(CALENDARS)
          .document(calendarId)
          .collection(TIMESLOTS)
          .document(timeSlotId)
          .updateData(deleteUserId);
    } catch (e) {
      print(e.toString());
    }
  }

  // UPDATE time slot
  Future updateTimeSlot(String calendarId, TimeSlot timeSlot,
      {int status}) async {
    if (status == 0) {
      Map<String, String> occupants =
          Map<String, String>.from(timeSlot.occupants);

      // leave time slot for each occupant
      occupants.forEach((userId, name) async {
        // removed await here
        removeOccupantFromTimeSlot(userId, calendarId, timeSlot.timeSlotId);
      });
    }
    // removed await here
    Firestore.instance
        .collection(CALENDARS)
        .document(calendarId)
        .collection(TIMESLOTS)
        .document(timeSlot.timeSlotId)
        .setData({
      if (status != null) 'status': status,
    }, merge: true);
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  /// REQUEST
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // CREATE request to join calendar
  Future<bool> createJoinCalendarRequest(String userId, String calendarId,
      {String message = ""}) async {
    try {
      DocumentSnapshot userSnapshot =
          await Firestore.instance.collection(USERS).document(userId).get();
      DocumentSnapshot calendarSnapshot = await Firestore.instance
          .collection(CALENDARS)
          .document(calendarId)
          .get();

      // if the user is already a follower or has a pending request, do nothing.
      if (Map<String, String>.from(calendarSnapshot.data['followers'])
              .containsKey(userId) ||
          Map<String, String>.from(calendarSnapshot.data['requests'])
              .containsValue(userId)) {
        return null;
      }

      if (calendarSnapshot.data['requiresJoinApproval'] as bool == false) {
        // removed await here
        addFollowerToCalendar(userId, calendarId);
        return true;
      }

      DateTime now = DateTime.now();

      // creates a request and gets requestId
      DocumentReference docRef =
          await Firestore.instance.collection(REQUESTS).add({
        'type': "calendar",
        'itemId': calendarId,
        'requesterId': userId,
        'requesterName': userSnapshot.data['displayName'],
        'ownerApprovers': calendarSnapshot.data['owners'],
        'otherApprovers': {},
        'hasOwnerApproval': false,
        'hasOtherApproval': true,
        'responses': {},
        'message': message,
        'createDate': now,
      });
      String newRequestId = docRef.documentID;

      // update outgoing requests for requester
      // removed await here
      Firestore.instance.collection(USERS).document(userId).updateData({
        "outgoingRequests.$newRequestId": calendarId,
      });

      // update incoming requests for approvers
      Map<String, String>.from(calendarSnapshot.data['owners'])
          .forEach((approverUserId, approverName) async {
        // removed await here
        Firestore.instance
            .collection(USERS)
            .document(approverUserId)
            .updateData({
          "incomingRequests.$newRequestId": calendarId,
        });
      });

      // update requests for calendar
      // removed await here
      Firestore.instance.collection(CALENDARS).document(calendarId).updateData({
        "requests.$newRequestId": userId,
      });

      return false;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // RESPOND to request to join calendar
  Future respondJoinCalendarRequest(
      String userId, Request req, int decision) async {
    // get the request object
    DocumentSnapshot requestSnapshot = await Firestore.instance
        .collection(REQUESTS)
        .document(req.requestId)
        .get();
    Request request = Request.fromSnapshot(requestSnapshot);

    // add the approver user's decision
    request.responses[userId] = decision;

    Map<String, int> ownerResponses = Map<String, int>.fromEntries(request
        .responses.entries
        .where((element) => request.ownerApprovers.containsKey(element.key)));
    // if the user is an owner, the request status will be adjusted based on their decision
    if (request.ownerApprovers.containsKey(userId)) {
      // if there is an approving owner response, then hasOwnerApproval is true
      request.hasOwnerApproval =
          ownerResponses.entries.where((element) => element.value == 1).length >
              0;
    }

    // if the request has passed, add user to calendar, then delete the request
    if (request.hasOwnerApproval) {
      // removed await here
      addFollowerToCalendar(request.requesterId, request.itemId);
      // removed await here
      deleteJoinCalendarRequest(request);
    }
    // else if the request has certain failed, delete the request from requests, users, and calendars
    else if (request.ownerApprovers.length == ownerResponses.length) {
      // if the number of people remaining is strictly less than the number of approvals needed
      // removed await here
      deleteJoinCalendarRequest(request);
    }
    // else, update the request in firestore
    else {
      // removed await here
      Firestore.instance
          .collection(REQUESTS)
          .document(request.requestId)
          .updateData({
        "responses.${request.requesterId}": decision,
      });
    }
  }

  // DELETE join calendar request
  Future deleteJoinCalendarRequest(Request request) async {
    // delete outgoing request for requester user
    Map<String, Object> deleteOutgoingRequestId = {};
    deleteOutgoingRequestId["outgoingRequests.${request.requestId}"] =
        FieldValue.delete();
    // removed await here
    Firestore.instance
        .collection(REQUESTS)
        .document(request.requesterId)
        .updateData(deleteOutgoingRequestId);

    Map<String, String> approvers = {};
    approvers.addAll(request.ownerApprovers);

    // delete incoming request for approver users
    approvers.forEach((approverUserId, approverName) async {
      Map<String, Object> deleteIncomingRequestId = {};
      deleteIncomingRequestId["incomingRequests.${request.requestId}"] =
          FieldValue.delete();
      // removed await here
      Firestore.instance
          .collection(USERS)
          .document(approverUserId)
          .updateData(deleteIncomingRequestId);
    });

    // delete request from calendar
    Map<String, Object> deleteCalendarRequestId = {};
    deleteCalendarRequestId["requests.${request.requestId}"] =
        FieldValue.delete();
    // removed await here
    Firestore.instance
        .collection(CALENDARS)
        .document(request.itemId)
        .updateData(deleteCalendarRequestId);

    // delete request object
    // removed await here
    Firestore.instance
        .collection(REQUESTS)
        .document(request.requestId)
        .delete();
  }

  // CREATE request to join calendar time slot
  // input: userId, calendarId, timeSlotId
  Future<bool> createJoinTimeSlotRequest(
      User user, Calendar calendar, TimeSlot timeSlot,
      {String message = ""}) async {
    try {
      // if the user is already an occupant or has a pending request, do nothing.
      if (Map<String, String>.from(timeSlot.occupants)
              .containsKey(user.userId) ||
          Map<String, String>.from(timeSlot.requests)
              .containsValue(user.userId)) {
        return null;
      }

      if (calendar.timeSlotRequiresOwnerApproval == false) {
        // removed await here
        addOccupantToTimeSlot(user, calendar.calendarId, timeSlot.timeSlotId);
        return true;
      }

      DateTime now = DateTime.now();
      Map approvers = {};
      approvers.addAll(calendar.owners);
      // If the time slot is full, add the occupants as approvers
      bool isFull = timeSlot.occupants.length >= timeSlot.limit;
      if (isFull) {
        approvers.addAll(timeSlot.occupants);
      } // else, only owner approval is required
      approvers = Map<String, String>.from(approvers);

      // creates a request and gets requestId
      DocumentReference docRef =
          await Firestore.instance.collection(REQUESTS).add({
        'type': "timeSlot",
        'itemId': timeSlot.timeSlotId,
        'requesterId': user.userId,
        'requesterName': user.displayName,
        'ownerApprovers': calendar.owners,
        'otherApprovers': timeSlot.occupants,
        'hasOwnerApproval': false,
        'hasOtherApproval': !isFull,
        'responses': {},
        'message': message,
        'createDate': now,
      });
      String newRequestId = docRef.documentID;

      // update outgoing requests for requester
      // removed await here
      Firestore.instance.collection(USERS).document(user.userId).updateData({
        "outgoingRequests.$newRequestId": timeSlot.timeSlotId,
      });

      // update incoming requests for approvers
      Map<String, String>.from(approvers)
          .forEach((approverUserId, approverName) async {
        // removed await here
        Firestore.instance
            .collection(USERS)
            .document(approverUserId)
            .updateData({
          "incomingRequests.$newRequestId": timeSlot.timeSlotId,
        });
      });

      // update requests for time slots
      // removed await here
      Firestore.instance
          .collection(CALENDARS)
          .document(calendar.calendarId)
          .collection(TIMESLOTS)
          .document(timeSlot.timeSlotId)
          .updateData({
        "requests.$newRequestId": user.userId,
      });

      return false;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // RESPOND to request to join time slot
  // TODO: if a time slot request is accepted, then delete other requests for the same time slot.
  Future respondJoinTimeSlotRequest(
      String userId, Request req, int decision) async {
    // get the request object
    DocumentSnapshot requestSnapshot = await Firestore.instance
        .collection(REQUESTS)
        .document(req.requestId)
        .get();
    Request request = Request.fromSnapshot(requestSnapshot);

    String calendarId = request.itemId.split("-")[0];

    // add the approver user's decision
    request.responses[userId] = decision;
    Map<String, int> ownerResponses = Map<String, int>.fromEntries(request
        .responses.entries
        .where((element) => request.ownerApprovers.containsKey(element.key)));
    Map<String, int> otherResponses = Map<String, int>.fromEntries(request
        .responses.entries
        .where((element) => request.otherApprovers.containsKey(element.key)));

    // if the user is an owner, update
    bool isOwner = request.ownerApprovers.containsKey(userId);
    bool isOther = request.otherApprovers.containsKey(userId);
    if (isOwner) {
      request.hasOwnerApproval = decision == 1
          ? true
          : ownerResponses.entries
                  .where((element) => element.value == 1)
                  .length >
              0;
    }
    // if the user is an other, update
    if (isOther) {
      request.hasOtherApproval = decision == 1
          ? true
          : otherResponses.entries
                  .where((element) => element.value == 1)
                  .length >
              0;
    }

    // if the request has passed, add user to calendar, then delete the request
    if (request.hasOwnerApproval && request.hasOtherApproval) {
      request.otherApprovers.forEach((kickedUserId, kickedName) async {
        // removed await here
        removeOccupantFromTimeSlot(kickedUserId, calendarId, request.itemId);
      });
      // removed await here
      addOccupantToTimeSlot(
          new User(
              userId: request.requesterId, displayName: request.requesterName),
          calendarId,
          request.itemId);
      // removed await here
      deleteTimeSlotRequest(request);
    }
    // else if the request has for certain failed,
    // then delete the request from requests, users, and calendars
    else if ((ownerResponses.length == request.ownerApprovers.length &&
            !request.hasOwnerApproval) ||
        (otherResponses.length == request.otherApprovers.length &&
            !request.hasOwnerApproval)) {
      // removed await here
      deleteTimeSlotRequest(request);
    }
    // else, update the request in firestore
    else {
      // removed await here
      Firestore.instance
          .collection(REQUESTS)
          .document(request.requestId)
          .updateData({
        if (isOwner) "hasOwnerApproval": request.hasOwnerApproval,
        if (isOther) "hasOtherApproval": request.hasOtherApproval,
        "responses.${request.requesterId}": decision,
      });
    }
  }

  // DELETE join time slot request
  Future deleteTimeSlotRequest(Request request) async {
    String calendarId = request.itemId.split("-")[0];

    // delete outgoing request for requester user
    Map<String, Object> deleteOutgoingRequestId = {};
    deleteOutgoingRequestId["outgoingRequests.${request.requestId}"] =
        FieldValue.delete();
    // removed await here
    Firestore.instance
        .collection(USERS)
        .document(request.requesterId)
        .updateData(deleteOutgoingRequestId);

    Map<String, String> approvers = {};
    approvers.addAll(request.ownerApprovers);
    approvers.addAll(request.otherApprovers);

    // delete incoming request for approver users
    approvers.forEach((approverUserId, approverName) async {
      Map<String, Object> deleteIncomingRequestId = {};
      deleteIncomingRequestId["incomingRequests.${request.requestId}"] =
          FieldValue.delete();
      // removed await here
      Firestore.instance
          .collection(USERS)
          .document(approverUserId)
          .updateData(deleteIncomingRequestId);
    });

    // delete request from time slot
    Map<String, Object> deleteTimeSlotRequestId = {};
    deleteTimeSlotRequestId["requests.${request.requestId}"] =
        FieldValue.delete();
    // removed await here
    Firestore.instance
        .collection(CALENDARS)
        .document(calendarId)
        .collection(TIMESLOTS)
        .document(request.itemId)
        .updateData(deleteTimeSlotRequestId);

    // delete request object
    // removed await here
    Firestore.instance
        .collection(REQUESTS)
        .document(request.requestId)
        .delete();
  }
}
