import 'package:flutter/material.dart';

/// A custom dropdown form field widget that provides a dropdown menu
/// with validation support, wrapped inside a form. This widget allows
/// users to select a value from a list of [dropdownItems] and performs
/// an action defined by [onChanged] when the selection changes.
///
/// Actions:
/// - Displays a dropdown menu using [DropdownButtonFormField].
/// - Calls [onChanged] when a new value is selected.
class DropdownService extends StatefulWidget {
  late final String hintText;
  late final List<DropdownMenuItem<String>> dropdownItems;
  final Function(String?) onChanged;

  DropdownService({
    required this.hintText,
    required this.dropdownItems,
    required this.onChanged,
  });

  @override
  _DropdownServiceState createState() => _DropdownServiceState();
}

class _DropdownServiceState extends State<DropdownService> {
  String? selectedValue;
  final _dropdownFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: screenWidth*0.9,
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
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'default',
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                  widget.onChanged(newValue);
                },
                items:
                widget.dropdownItems.map((DropdownMenuItem<String> item) {
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
              ), // Use provided dropdown items
            ],
          ),
        ),
      ),
    );
  }

  void resetSelectedValue() {
    setState(() {
      selectedValue = null;
    });
  }

}
