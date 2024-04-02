import 'package:flutter/material.dart';

class DropdownFormField extends StatefulWidget {
  late final String hintText;
  late final List<DropdownMenuItem<String>> dropdownItems;

  DropdownFormField({required this.hintText, required this.dropdownItems});

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? selectedValue;
  final _dropdownFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 350,
        height: 60,
        child: Form(
          key: _dropdownFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: EdgeInsets.all(17),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(fontSize: 16, fontFamily: 'default', color: Colors.black, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.hintText;
                  }
                  return null;
                },
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: widget.dropdownItems.map((DropdownMenuItem<String> item) {
                  return DropdownMenuItem<String>(
                    value: item.value,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: Text(
                        item.value!,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'default',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                ),// Use provided dropdown items
            ],
          ),
        ),
      ),
    );
  }
}