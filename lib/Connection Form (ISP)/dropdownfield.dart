import 'package:flutter/material.dart';

class DropdownFormField extends StatefulWidget {
  final String hintText;
  final List<String> dropdownItems;
  final String? initialValue;
  final ValueChanged<String?>? onChanged; // Define onChanged callback

  DropdownFormField({required this.hintText, required this.dropdownItems, this.initialValue, this.onChanged});

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: InputBorder.none,
        /*border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),*/
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'default',
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: _selectedValue,
      items: widget.dropdownItems.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item,
          style: TextStyle(
            color: Colors.black ,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'default',
          ),),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedValue = _selectedValue == value ? null : value;
        });
        // Call the onChanged callback provided by the parent widget
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}