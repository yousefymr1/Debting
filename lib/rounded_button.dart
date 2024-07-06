import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const RoundedButton(
      {required this.title, required this.colour, required this.onPressed,required this.icon});
  final Color colour;
  final String title;
    final IconData icon;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
            icon,
            color: Colors.white,
          ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
                
              ),
                
            ],
          ),
        ),
      ),
    );
  }
}
