import 'package:flutter/material.dart';

class AppConstants {
  String logoWithBlueBackground = "assets/images/logo_blue_background.png";
  String logoWithWhiteBackground = "assets/images/logo.png";

  Color appDarkBlue = const Color(0xFF005DF4);
  Color appRed = const Color(0xFFE40101);
  Color appGreen = const Color(0xFF00E03F);
  Color appYellow = const Color(0xFFC1B900);
  Color appWhite = const Color(0xFFFFFFFF);
  Color appDarkWhite = const Color(0xFFF5F5F5);
}

class AppBlueButton extends StatelessWidget {
  const AppBlueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          fixedSize: const Size(350, 50),
          foregroundColor: AppConstants().appWhite,
          backgroundColor: AppConstants().appDarkBlue,
        ),
        child: Text(
          'Sign In',
          style: TextStyle(
              letterSpacing: 1, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  const AppTextField(
      {super.key,
      required this.labelText,
      required this.validationText,
      required this.prefixIcon,
      this.maxCharacters,
      this.counter,
      required this.keyboardType,
      this.hideText = false,
      required this.controller,
      this.suffixIcon});
  final String labelText;
  final String validationText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final int? counter;
  final int? maxCharacters;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool hideText;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      child: TextFormField(
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Color.fromARGB(255, 0, 0, 0),
        cursorHeight: 26,
        obscureText: widget.hideText,
        controller: widget.controller,
        maxLength: widget.maxCharacters,
        decoration: InputDecoration(
          fillColor: const Color(0xFFEAEAEA),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              width: 1,
              color: Color.fromARGB(255, 59, 59, 59),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: AppConstants().appDarkBlue,
            ),
          ),
          counter: widget.maxCharacters != null
              ? Text("${widget.counter}/${widget.maxCharacters}")
              : SizedBox(),
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
          labelText: widget.labelText,
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return widget.validationText;
          }
          return null;
        },
      ),
    );
  }
}
