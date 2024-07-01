import 'package:ambulance_dispatch_application/Models/ticket.dart';
import 'package:ambulance_dispatch_application/View_Models/Ticket_Management/ticket_management.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TicketViewPage extends StatefulWidget {
  const TicketViewPage({super.key});

  @override
  State<TicketViewPage> createState() => _TicketViewPageState();
}

class _TicketViewPageState extends State<TicketViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Selector<TicketManager, Ticket>(
        selector: (p0, p1) => p1.viewedTicket!,
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(35),
            child: ListView(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text('ID: ',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(
                  height: 20,
                ),
                Text(value.ticketId),
                const SizedBox(
                  height: 40,
                ),
                Text('Book on',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    '${value.bookedAt.toDate().day}/${value.bookedAt.toDate().month}/${value.bookedAt.toDate().year} at ${value.bookedAt.toDate().hour}:${value.bookedAt.toDate().minute}'),
                const SizedBox(
                  height: 40,
                ),
                Text('Closed on',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    '${value.closedAt!.toDate().day}/${value.closedAt!.toDate().month}/${value.closedAt!.toDate().year} at ${value.closedAt!.toDate().hour}:${value.closedAt!.toDate().minute}'),
                const SizedBox(
                  height: 40,
                ),
                Text('Description',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(
                  height: 20,
                ),
                Text(value.description),
                const SizedBox(
                  height: 40,
                ),
                Text('Energency Level',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(
                  height: 20,
                ),
                Text('${value.emergencyLevel!}'),
              ],
            ),
          );
        },
      )),
    );
  }
}
