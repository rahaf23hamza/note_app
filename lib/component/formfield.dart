import 'package:flutter/material.dart';

class FormofField extends StatelessWidget {
  final String textfield;
  final String hinttext;
  final Icon iconfield;
  final TextEditingController MyController;
  final String? Function(String?)? validator;

  const FormofField(
      {super.key,
      required this.textfield,
      required this.hinttext,
      required this.iconfield, required this.MyController,  required this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
             padding: const EdgeInsets.only(top: 18.0, left: 18.0),
             child: Text(
                textfield,
                style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 25.5,
                    fontWeight: FontWeight.bold),
              ),
           ),
          Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(right: 18, left: 18),
              child: TextFormField(
                controller: MyController,
                validator: validator,
                decoration: InputDecoration(
                  fillColor: Colors.blue[200],
                  filled: true,
                  hintText: hinttext,
                  hintStyle: TextStyle(color: Colors.blue[900], fontSize: 15.5),
                  prefixIcon: iconfield,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          )
        ],
      );
  }
}
