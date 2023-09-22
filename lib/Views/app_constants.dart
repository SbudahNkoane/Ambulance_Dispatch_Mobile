import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  String logoWithBlueBackground = "assets/images/logo_blue_background.png";
  String logoWithWhiteBackground = "assets/images/logo.png";

  Color appDarkBlue = const Color(0xFF005DF4);
  Color appRed = const Color(0xFFE40101);
  Color appGreen = const Color(0xFF00E03F);
  Color appYellow = const Color(0xFFC1B900);
  Color appWhite = const Color(0xFFFFFFFF);
  Color appDarkWhite = const Color(0xFFF5F5F5);
  Color appGrey = const Color(0xFFEAEAEA);
}

class AppBlueButton extends StatefulWidget {
  const AppBlueButton({super.key, required this.onPressed, required this.text});
  final void Function() onPressed;
  final String text;

  @override
  State<AppBlueButton> createState() => _AppBlueButtonState();
}

class _AppBlueButtonState extends State<AppBlueButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          fixedSize: const Size(350, 50),
          foregroundColor: AppConstants().appWhite,
          backgroundColor: AppConstants().appDarkBlue,
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
              letterSpacing: 1, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    this.maxCharacters,
    this.counter,
    required this.keyboardType,
    this.hideText = false,
    required this.controller,
    this.suffixIcon,
    required this.validator,
  });
  final String labelText;

  final IconData prefixIcon;
  final IconData? suffixIcon;
  final int? counter;
  final int? maxCharacters;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool hideText;
  final String? Function(String? text)? validator;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: const Color.fromARGB(255, 0, 0, 0),
        cursorHeight: 26,
        obscureText: widget.hideText,
        controller: widget.controller,
        maxLength: widget.maxCharacters,
        decoration: InputDecoration(
          label: Text(widget.labelText),
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
          counter: widget.maxCharacters != null
              ? Text("${widget.counter}/${widget.maxCharacters}")
              : const SizedBox(),
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 18,
          ),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              widget.suffixIcon,
              size: 18,
            ),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
