import 'package:ambulance_dispatch_application/Models/ticket.dart';
import 'package:ambulance_dispatch_application/Routes/app_routes.dart';
import 'package:ambulance_dispatch_application/View_Models/Ticket_Management/ticket_management.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class UserTicketTrackingPage extends StatefulWidget {
  final Ticket ticket;
  const UserTicketTrackingPage({super.key, required this.ticket});

  @override
  State<UserTicketTrackingPage> createState() => _UserTicketTrackingPageState();
}

class _UserTicketTrackingPageState extends State<UserTicketTrackingPage> {
  Placemark? pickUpLocation;
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
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  @override
  void initState() {
    convertGeoPointToAddress();
    super.initState();
  }

  Future convertGeoPointToAddress() async {
    final response = await placemarkFromCoordinates(
        widget.ticket.pickUpLocation.latitude,
        widget.ticket.pickUpLocation.longitude);

    pickUpLocation = response[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Ticket Details'),
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
              ),
              child: StreamBuilder(
                stream: context
                    .read<TicketManager>()
                    .ticketStatusStreamer(widget.ticket.ticketId),
                builder: (context, snapshot) {
                  return SingleChildScrollView(
                      child: Selector<TicketManager, Ticket>(
                    selector: (p0, p1) => p1.bookedTicket!,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          Text(
                            'Ticket Recieved',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                          Text(
                            '${weekdays[widget.ticket.bookedAt.toDate().weekday - 1]}\n${widget.ticket.bookedAt.toDate().hour}h:${widget.ticket.bookedAt.toDate().minute}m, ${widget.ticket.bookedAt.toDate().day} ${months[widget.ticket.bookedAt.toDate().month - 1]} ${widget.ticket.bookedAt.toDate().year}\n',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.18,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pick up location',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        pickUpLocation != null
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${pickUpLocation!.street}',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    '${pickUpLocation!.locality}',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    '${pickUpLocation!.subLocality}',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    '${pickUpLocation!.postalCode}',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    '${pickUpLocation!.administrativeArea}',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        Text(
                                          'Patient Condition',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          value.description,
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                          const Divider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                          value.status == 'Dispatched'
                              ? Column(
                                  children: [
                                    Text(
                                      'On the way, keep calm...',
                                      style: GoogleFonts.moul(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20),
                                    ),
                                    Lottie.asset(
                                        'assets/animations/Ambulance_Dispatched.json'),
                                    value.dispatchedAmbulance != null
                                        ? TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  AppRouteManager
                                                      .userAmbulanceTrackingPage);
                                            },
                                            child: Text(
                                              'Track Ambulance location',
                                              style: GoogleFonts.moul(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25),
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                  ],
                                )
                              : widget.ticket.status == 'Ambulance Arrived'
                                  ? Column(
                                      children: [
                                        Text(
                                          'Pick up location',
                                          style: GoogleFonts.moul(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Text(
                                          'Finding an ambulance',
                                          style: GoogleFonts.moul(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                20,
                                          ),
                                        ),
                                        Text(
                                          'Please wait...',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                        Lottie.asset(
                                          'assets/animations/search.json',
                                          fit: BoxFit.fill,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                        ),
                                      ],
                                    ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 10,
                          ),
                        ],
                      );
                    },
                  ));
                },
              )),
        ));
  }
}
