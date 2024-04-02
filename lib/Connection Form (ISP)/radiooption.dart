import 'package:flutter/material.dart';

class RadioListTileGroup extends StatefulWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String)? onChanged;

  const RadioListTileGroup({
    Key? key,
    required this.options,
    this.selectedOption,
    this.onChanged,
  }) : super(key: key);

  @override
  _RadioListTileGroupState createState() => _RadioListTileGroupState();
}

class _RadioListTileGroupState extends State<RadioListTileGroup> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption ?? widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          horizontalTitleGap: 2,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Wrap(
        children: widget.options.map((option) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.45,
            child: RadioListTile<String>(
              title: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color:
                  _selectedOption == option ? Colors.deepPurple : Colors.green,
                ),
              ),
              value: option,
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value!;
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                });
              },
              activeColor:
                  _selectedOption == option ? Colors.deepPurple : Colors.green,
              contentPadding: EdgeInsets.symmetric(horizontal: 2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
