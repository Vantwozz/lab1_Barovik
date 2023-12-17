import 'package:barovik/main.dart';
import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {
  RadioButtons({
    required this.op,
    required this.onValueChanged,
    super.key,
  });

  Operation op;
  final Function onValueChanged;

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: const Text(
              '+',
              style: TextStyle(fontSize: 25),
            ),
            leading: Radio<Operation>(
              value: Operation.plus,
              groupValue: widget.op,
              onChanged: (Operation? value) {
                setState(() {
                  widget.op = value!;
                });
                widget.onValueChanged(value);
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text(
              '-',
              style: TextStyle(fontSize: 25),
            ),
            leading: Radio<Operation>(
              value: Operation.minus,
              groupValue: widget.op,
              onChanged: (Operation? value) {
                setState(() {
                  widget.op = value!;
                });
                widget.onValueChanged(value);
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text(
              'x',
              style: TextStyle(fontSize: 25),
            ),
            leading: Radio<Operation>(
              value: Operation.multiply,
              groupValue: widget.op,
              onChanged: (Operation? value) {
                setState(() {
                  widget.op = value!;
                });
                widget.onValueChanged(value);
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text(
              '/',
              style: TextStyle(fontSize: 25),
            ),
            leading: Radio<Operation>(
              value: Operation.divide,
              groupValue: widget.op,
              onChanged: (Operation? value) {
                setState(() {
                  widget.op = value!;
                });
                widget.onValueChanged(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
