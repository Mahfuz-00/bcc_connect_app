import 'package:flutter/material.dart';

/// A widget that displays a group of radio buttons based on a list of options.
///
/// This widget allows users to select one option from a list of radio buttons.
///
/// **Variables:**
/// - [options]: List of options to be displayed as radio buttons.
/// - [selectedOption]: Currently selected option, if any.
/// - [onChanged]: Callback function to handle option changes.
class RadioListTileGroup extends StatefulWidget {
  final List<String>
      options; // List of options to be displayed as radio buttons.
  final String? selectedOption; // Currently selected option, if any.
  final Function(String)?
      onChanged; // Callback function to handle option changes.

  const RadioListTileGroup({
    Key? key,
    required this.options, // Required list of options.
    this.selectedOption, // Optional parameter for initially selected option.
    this.onChanged, // Optional callback function for handling changes.
  }) : super(key: key);

  @override
  _RadioListTileGroupState createState() => _RadioListTileGroupState();
}

class _RadioListTileGroupState extends State<RadioListTileGroup> {
  late String _selectedOption; // Holds the currently selected option.

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption ??
        widget.options.first; // Initialize _selectedOption.
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          horizontalTitleGap:
              2, // Adjusts the horizontal gap between the tile's content and the edge.
        ),
        splashColor: Colors.transparent, // Disables splash color effect.
        highlightColor: Colors.transparent, // Disables highlight color effect.
      ),
      child: Wrap(
        children: widget.options.map((option) {
          return SizedBox(
            height: MediaQuery.of(context).size.height *
                0.06, // Sets height of each radio list tile.
            width: MediaQuery.of(context).size.width *
                0.45, // Sets width of each radio list tile.
            child: RadioListTile<String>(
              title: Text(
                option, // Displays the option text.
                style: TextStyle(
                  fontFamily: 'default', // Sets the font family.
                  fontWeight: FontWeight.bold, // Makes the text bold.
                  fontSize: 16,
                  color: _selectedOption == option
                      ? Colors.deepPurple
                      : Colors.green, // Changes text color based on selection.
                ),
              ),
              value: option,
              // Value associated with this radio button.
              groupValue: _selectedOption,
              // Currently selected option.
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value!; // Update selected option.
                  if (widget.onChanged != null) {
                    widget
                        .onChanged!(value); // Invoke the callback if provided.
                  }
                });
              },
              activeColor:
                  _selectedOption == option ? Colors.deepPurple : Colors.green,
              // Sets the color of the active radio button.
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 2), // Sets padding around the content.
            ),
          );
        }).toList(),
      ),
    );
  }
}
