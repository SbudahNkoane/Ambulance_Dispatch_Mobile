import 'package:ambulance_dispatch_application/Models/ticket.dart';
import 'package:ambulance_dispatch_application/Services/locator_service.dart';
import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';

class TicketManager with ChangeNotifier {
  List<Ticket> _userTickets = [];
  List<Ticket> get userTickets => _userTickets;

  bool _showprogress = false;
  bool get showProgress => _showprogress;

  String _userprogresstext = "";
  String get userProgressText => _userprogresstext;

  Future<String> submitTicket(String userID, Ticket ticket) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Requesting Ambulance...';
    notifyListeners();
    try {
      await database.collection('Ticket').doc().set(ticket.toJson()).onError(
            (error, stackTrace) => state = error.toString(),
          );
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }
    return state;
  }

  Future<String> getTickets(String userID) async {
    String state = 'OK';
    _showprogress = true;
    _userprogresstext = 'Getting Tickets...';
    notifyListeners();
    try {
      await database
          .collection('Ticket')
          .where('User_Id', isEqualTo: userID)
          .get()
          .then((querySnapshot) {})
          .onError((error, stackTrace) {});
    } catch (e) {
      state = e.toString();
    } finally {
      _showprogress = false;
      notifyListeners();
    }
    return state;
  }
}
