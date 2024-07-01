import 'package:ambulance_dispatch_application/Models/ticket.dart';
import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/Ticket_Management/ticket_management.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class UserTicketsPage extends StatefulWidget {
  const UserTicketsPage({super.key});

  @override
  State<UserTicketsPage> createState() => _UserTicketsPageState();
}

class _UserTicketsPageState extends State<UserTicketsPage> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context
          .read<TicketManager>()
          .userTicketsStreamer(context.read<UserManager>().userData!.userID!),
      builder: (context, snapshot) {
        return Selector<TicketManager, List<Ticket>>(
          selector: (p0, p1) => p1.userTickets,
          builder: (context, value, child) {
            return value.isNotEmpty
                ? ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            if (value[index].status != "Cancelled" &&
                                value[index].status != "Closed") {
                              if (value[index].ticketId ==
                                  context
                                      .read<TicketManager>()
                                      .bookedTicket!
                                      .ticketId) {
                                Navigator.of(context).pushNamed(
                                  AppRouteManager.userTicketTrackingPage,
                                );
                              }
                            } else {
                              context.read<TicketManager>().viewTicket(index);
                              Navigator.of(context).pushNamed(
                                AppRouteManager.userTicketViewPage,
                              );
                            }
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 70,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListTile(
                                      title: Text(
                                        'Ticket No:',
                                        style: GoogleFonts.alfaSlabOne(),
                                      ),
                                      subtitle: Text(
                                        '${index + 1}',
                                        style: GoogleFonts.alfaSlabOne(),
                                      ),
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                            color: value[index].status ==
                                                    'Dispatched'
                                                ? const Color.fromARGB(
                                                    255, 7, 44, 255)
                                                : value[index].status ==
                                                        'Closed'
                                                    ? Colors.green
                                                    : value[index].status ==
                                                            'Searching for an Ambulance'
                                                        ? Colors.orange
                                                        : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        width: 120,
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            value[index].status == 'Dispatched'
                                                ? 'Dispatched'
                                                : value[index].status ==
                                                        "Closed"
                                                    ? 'Complete'
                                                    : value[index].status ==
                                                            'Searching for an Ambulance'
                                                        ? 'Waiting'
                                                        : 'Pending',
                                            style: GoogleFonts.alfaSlabOne(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Opened:',
                                          style: GoogleFonts.alfaSlabOne(),
                                        ),
                                        Text(
                                          'Closed:',
                                          style: GoogleFonts.alfaSlabOne(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${value[index].bookedAt.toDate().day} ${months[value[index].bookedAt.toDate().month - 1]} ${value[index].bookedAt.toDate().year}',
                                          style: GoogleFonts.inter(),
                                        ),
                                        Text(
                                          value[index].closedAt != null
                                              ? '${value[index].closedAt!.toDate().day} ${months[value[index].closedAt!.toDate().month - 1]} ${value[index].closedAt!.toDate().year}'
                                              : '.............',
                                          style: GoogleFonts.inter(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${value[index].bookedAt.toDate().hour}:${value[index].bookedAt.toDate().minute}',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          value[index].closedAt != null
                                              ? '${value[index].closedAt!.toDate().hour}:${value[index].closedAt!.toDate().minute}'
                                              : '',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You have not made a request yet.\nWe look forward to making your health our priority.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: const Color.fromARGB(255, 102, 102, 102)),
                        ),
                        Lottie.asset('assets/animations/no_tickets.json'),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }
}
