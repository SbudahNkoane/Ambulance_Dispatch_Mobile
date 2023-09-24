import 'package:ambulance_dispatch_application/Views/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserRequestFromPage extends StatefulWidget {
  const UserRequestFromPage({super.key});

  @override
  State<UserRequestFromPage> createState() => _UserRequestFromPageState();
}

class _UserRequestFromPageState extends State<UserRequestFromPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppConstants().appDarkWhite,
        centerTitle: true,
        toolbarHeight: 240,
        title: Column(
          children: [
            Image.asset(
              AppConstants().logoWithWhiteBackground,
              height: 150,
              width: 150,
            ),
            const Text("Request Form"),
          ],
        ),
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Your Are nearly done'),
              SizedBox(
                height: 20,
              ),
              Form(
                child: Column(
                  children: [
                    Text(
                        'Give a short description of the Patient\'s condition'),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        maxLength: 100,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: const Color.fromARGB(255, 0, 0, 0),
                        cursorHeight: 26,
                        decoration: InputDecoration(
                          label: Text('Type here...'),
                          labelStyle: GoogleFonts.orelegaOne(),
                          fillColor: AppConstants().appGrey,
                          filled: true,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 59, 59, 59),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 59, 59, 59),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 59, 59, 59),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              width: 2,
                              color: AppConstants().appDarkBlue,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.view_timeline_sharp,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Pick Up Location'),
                    SizedBox(
                      height: 600,
                      width: MediaQuery.of(context).size.width / 1.05,
                      child: Card(
                        color: Color.fromARGB(255, 196, 196, 196),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text('Use My Device Location'),
                              Checkbox(
                                value: false,
                                onChanged: (value) {
                                  setState(() {
                                    print(value);
                                    value = !value!;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text('OR'),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Street Address'),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                                cursorHeight: 24,
                                decoration: InputDecoration(
                                  label: Text('Type here...'),
                                  labelStyle: GoogleFonts.orelegaOne(),
                                  fillColor: AppConstants().appGrey,
                                  filled: true,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 59, 59, 59),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 59, 59, 59),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 59, 59, 59),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: AppConstants().appDarkBlue,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.pin_drop,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('City'),
                                  Text('State/Province')
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      cursorColor:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      cursorHeight: 26,
                                      decoration: InputDecoration(
                                        label: Text('Type here...'),
                                        labelStyle: GoogleFonts.orelegaOne(),
                                        fillColor: AppConstants().appGrey,
                                        filled: true,
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: AppConstants().appDarkBlue,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.view_timeline_sharp,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      cursorColor:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      cursorHeight: 26,
                                      decoration: InputDecoration(
                                        label: Text('Type here...'),
                                        labelStyle: GoogleFonts.orelegaOne(),
                                        fillColor: AppConstants().appGrey,
                                        filled: true,
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          // borderSide: const BorderSide(
                                          //   width: 1,
                                          //   color:
                                          //       Color.fromARGB(255, 59, 59, 59),
                                          // ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          // borderSide: BorderSide(
                                          //   width: 2,
                                          //   color: AppConstants().appDarkBlue,
                                          // ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.view_timeline_sharp,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Postal/Zip Code'),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 75, right: 75),
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    cursorColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    cursorHeight: 24,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.pin_drop,
                                        size: 18,
                                      ),
                                      hintText: 'Type here...',
                                      hintStyle: GoogleFonts.orelegaOne(),
                                      fillColor: AppConstants().appGrey,
                                      filled: true,
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromARGB(255, 59, 59, 59),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromARGB(255, 59, 59, 59),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromARGB(255, 59, 59, 59),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: AppConstants().appDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AppBlueButton(onPressed: () {}, text: 'Request Now'),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
