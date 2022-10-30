import 'package:flutter/material.dart';
import '../color.dart';

Widget TitleBold(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 16),
    child: Text(title,
        style: TextStyle(
            color: CColor.text, fontSize: 34, fontWeight: FontWeight.bold)),
  );
}

Widget InputField(
    {IconData icon,
    String hint,
    TextEditingController controller,
    String Function(String) validator,
    bool multiline = false}) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 500),
    child: TextFormField(
      controller: controller,
      style: TextStyle(color: CColor.text),
      decoration: InputDecoration(
        icon: (icon != null) ? Icon(icon, color: CColor.text) : null,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white12),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CColor.card,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CColor.text,
          ),
        ),
      ),
      validator: validator,
      keyboardType: multiline ? TextInputType.multiline : null,
      maxLines: multiline ? null : 1,
    ),
  );
}

String Capitalize(String text) {
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

class DropdownMenu extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final List<String> item;

  const DropdownMenu({Key key, this.controller, this.icon, this.item})
      : super(key: key);

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  @override
  void initState() {
    if (widget.controller.text.length == 0) {
      widget.controller.text = widget.item[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                widget.icon,
                size: 24,
                color: CColor.text,
              ),
            ),
          ],
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: widget.controller.text,
                style: TextStyle(color: CColor.text, fontSize: 17),
                dropdownColor: CColor.card,
                items: widget.item.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget.controller.text = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
