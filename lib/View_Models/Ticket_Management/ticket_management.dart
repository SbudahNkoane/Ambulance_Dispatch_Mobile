import 'package:ambulance_dispatch_application/Models/ticket.dart';

import 'package:ambulance_dispatch_application/Views/app_constants.dart';

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

  Stream ticketStatusStreamer(String ticketId) {
    return database.collection('Ticket').doc(ticketId).snapshots();
  }

  Stream userTicketsStreamer(String userID) {
    return database
        .collection('Ticket')
        .where('User_Id', isEqualTo: userID)
        .snapshots();
  }

  Future<Ticket> updateBookedTicket() async {
    String state = 'OK';

    try {
      database
          .collection('Ticket')
          .doc(_bookedTicket!.ticketId)
          .snapshots()
          .listen(
        (event) async {
          if (event.exists) {
            _bookedTicket = Ticket.fromJson(event.data());
            notifyListeners();
          }
        },
      );
    } catch (e) {
      state = e.toString();
    }
    return _bookedTicket!;
  }

  Future<String> submitTicket(String userID, Ticket ticket) async {
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
        //Firebase query====================
        final query = database
            .collection('Ticket')
            .where('User_Id', isEqualTo: userID)
            .where('Booked_At', isEqualTo: ticket.bookedAt);
        //=========Listen to updates=============

        await query.get().then((value) async {
          await database
              .collection('Ticket')
              .doc(value.docs[0].id)
              .update(
                {'Ticket_Id': value.docs[0].id},
              )
              .onError((error, stackTrace) => null)
              .then((su) async {
                await database
                    .collection('Ticket')
                    .doc(value.docs[0].id)
                    .get()
                    .then((value) async {
                  _bookedTicket = Ticket.fromJson(value.data());
                  updateBookedTicket();
                });
              });
        });
      }).onError((error, stackTrace) => Future.error(error.toString()));
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }

    return state;
  }

  void trackMyTickets(String userID) {
    database
        .collection('Ticket')
        .where('User_Id', isEqualTo: userID)
        .snapshots()
        .listen((event) async {
      if (event.docs.isNotEmpty) {
        _userTickets = [];
        for (var ticket in event.docs) {
          _userTickets.add(
            Ticket.fromJson(
              ticket.data(),
            ),
          );
        }
      } else {
        _userTickets = [];
      }
      notifyListeners();
    });
  }

  Future<String> getTickets(String userID) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Getting Tickets...';
    notifyListeners();
    final docRef =
        database.collection('Ticket').where('User_Id', isEqualTo: userID);

    try {
      await docRef.get().then((querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          _userTickets = [];
          for (var ticket in querySnapshot.docs) {
            _userTickets.add(
              Ticket.fromJson(
                ticket.data(),
              ),
            );
          }
        } else {
          _userTickets = [];
        }
        trackMyTickets(userID);
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
