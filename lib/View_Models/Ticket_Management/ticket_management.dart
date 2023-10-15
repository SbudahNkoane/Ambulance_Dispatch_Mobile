import 'package:ambulance_dispatch_application/Models/ticket.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TicketManager with ChangeNotifier {
  List<Ticket> _userTickets = [];
  List<Ticket> get userTickets => _userTickets;

  Ticket? _bookedTicket;
  Ticket? get bookedTicket => _bookedTicket;

  bool _showprogress = false;
  bool get showProgress => _showprogress;

  String _userprogresstext = "";
  String get userProgressText => _userprogresstext;

  Future<Map<String, dynamic>> submitTicket(
      String userID, Ticket ticket) async {
    String state = 'OK';

    _showprogress = true;
    _userprogresstext = 'Requesting Ambulance...';
    notifyListeners();
    try {
      await database
          .collection('Ticket')
          .doc()
          .set(ticket.toJson())
          .onError((error, stackTrace) => state = error.toString())
          .then((value) async {
        final query = database
            .collection('Ticket')
            .where('User_Id', isEqualTo: userID)
            .where('Booked_At', isEqualTo: ticket.bookedAt);
        database
            .collection('Ticket')
            .where('User_Id', isEqualTo: userID)
            .where('Booked_At', isEqualTo: ticket.bookedAt)
            .snapshots()
            .listen((event) async {
          _bookedTicket = await Ticket.fromJson(event.docs[0].data());
        });
        query.snapshots().listen((event) async {
          _bookedTicket = await Ticket.fromJson(event.docs[0].data());
        });
        await query.get().then((value) async {
          _bookedTicket = await Ticket.fromJson(value.docs[0].data());
        });
        // bookedTicket=await Ticket.fromJson();  ;
      }).onError((error, stackTrace) => Future.error(error.toString()));
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }
    return {
      'state': state,
      'ticket': _bookedTicket,
    };
  }

  Future<String> getTickets(String userID) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Getting Tickets...';
    notifyListeners();
    final docRef =
        database.collection('Ticket').where('User_Id', isEqualTo: userID);
    docRef.snapshots().listen((event) async {
      _userTickets = [];
      for (var ticket in event.docs) {
        _userTickets.add(
          await Ticket.fromJson(
            ticket.data(),
          ),
        );
      }
    });
    try {
      await database
          .collection('Ticket')
          .where('User_Id', isEqualTo: userID)
          .get()
          .then((querySnapshot) async {
        _userTickets = [];
        for (var ticket in querySnapshot.docs) {
          _userTickets.add(
            await Ticket.fromJson(
              ticket.data(),
            ),
          );
        }
      }).onError((error, stackTrace) {});
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }
    return state;
  }
}
