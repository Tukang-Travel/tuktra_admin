import 'package:flutter/material.dart';

// const baseURL = 'http://127.0.0.1:8000/api';
const baseURL = 'http://10.0.2.2:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const userFeeds = '$baseURL/feeds';

const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const other = 'Something went wrong, try again!';

class TagCheckbox extends StatefulWidget {
  final ValueChanged<bool?>? onChanged;
  final bool checked;
  final String text;

  const TagCheckbox({
    super.key,
    this.onChanged,
    required this.text,
    required this.checked,
  });

  @override
  State<TagCheckbox> createState() => _TagCheckboxState();
}

class _TagCheckboxState extends State<TagCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged?.call(!widget.checked);
      },
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.checked
                ? const Color.fromARGB(255, 82, 114, 255)
                : Colors.grey,
            width: 2.0, // Border width
          ),
          borderRadius: BorderRadius.circular(20.0), // Border radius
          color: widget.checked
              ? const Color.fromARGB(255, 82, 114, 255).withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Center(
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.checked ? Colors.blue : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration formInputDecoration(String hint, Icon icon, bool fill, Color? color) {
  return InputDecoration(
    filled: fill,
    fillColor: color,
    prefixIcon: icon,
    hintText: hint,
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromARGB(128, 170, 188, 192),
        width: 1.0
      ),
      borderRadius: BorderRadius.circular(20)
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromARGB(128, 170, 188, 192),
      ),
      borderRadius: BorderRadius.circular(20)
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20)
    )
  );
}


Container authenticationOption(double w, double h, String auth) {
  return Container(
    width: w * 0.9,
    height: h * 0.07, // one third of the page
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      image: const DecorationImage(
          image: AssetImage('asset/images/signup_login_page.jpg'),
          fit: BoxFit.cover),
    ),
    child: Center(
      child: Text(auth,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
    ),
  );
}

Container primaryButton(double w, double h, String hint, DecorationImage img) {
  return Container(
    width: w * 0.9,
    height: h * 0.07, // one third of the page
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      image: img,
    ),
    child: Center(
      child: Text(hint,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
    ),
  );
}
