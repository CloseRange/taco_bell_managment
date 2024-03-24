// ignore_for_file: no_logic_in_create_state, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taco_bell_managment/util/style_sheet.dart';

class InputGroup {
  final Map<String, TextEditingController> _data = {};
  final Map<String, _InputGroupBox> _dataWidgets = {};
  final Map<String, bool> _errors = {};

  InputGroup(List<String> widgets) {
    for (int i = 0; i < widgets.length; i++) {
      _data[widgets[i]] = TextEditingController();
      _errors[widgets[i]] = false;
    }
  }

  String get(String key) {
    print("==>" + (_data[key]?.text ?? ""));
    return _data[key]?.text ?? "";
  }

  void setError(String key, bool isError) {
    _dataWidgets[key]?.isError = isError;
    _errors[key] ??= isError;
  }

  void clearField(String key) {
    _data[key]?.clear();
  }

  Widget field(
    BuildContext context,
    String key, {
    String? hint,
    bool obscure = false,
    bool isNumber = false,
  }) {
    if (_data[key] == null) return const Text("Error: No key found");
    _dataWidgets[key] =
        _InputGroupBox(_data[key]!, hint ?? key, obscure, isNumber);
    _dataWidgets[key]?.isError = _errors[key] ?? true;
    return _dataWidgets[key]!;
  }

  operator [](String s) => _data[s]?.text ?? "Invalid key";
}

// ignore: must_be_immutable
class _InputGroupBox extends StatefulWidget {
  var hint = "";
  var obscure = false;
  var isNumber = false;
  var isError = false;
  TextEditingController controller;
  _InputGroupBox(this.controller, this.hint, this.obscure, this.isNumber);

  @override
  State<_InputGroupBox> createState() => _InputGroupBoxState();
}

class _InputGroupBoxState extends State<_InputGroupBox> {
  _InputGroupBoxState();

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.getInput().main,
        border: Border.all(
            color: widget.isError
                ? Palette.getError().main
                : Palette.getInput().text),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Theme(
          data: Theme.of(context).copyWith(
              textSelectionTheme: const TextSelectionThemeData(
                  // selectionColor: Palette.getTint().light,
                  // cursorColor: Colors.red,
                  // selectionHandleColor: Colors.black,
                  )),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: widget.hint,
              labelStyle: widget.isError
                  ? TextStyle(color: Palette.getError().main)
                  : null,
              // isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            ),
            controller: widget.controller,
            obscureText: widget.obscure,
            keyboardType:
                widget.isNumber ? TextInputType.number : TextInputType.text,
            // onChanged: (value) => {},
            // cursorColor: Palette.getTint().main,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class EmphesizedButton extends StatefulWidget {
  String text;
  void Function()? callback;
  Future<dynamic> Function()? asyncCallback;
  bool enabled;
  bool loading;

  EmphesizedButton(
    this.text, {
    this.asyncCallback,
    this.callback,
    this.loading = false,
    this.enabled = true,
    super.key,
  });

  @override
  State<EmphesizedButton> createState() => _EmphesizedButtonState();
}

class _EmphesizedButtonState extends State<EmphesizedButton> {
  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? ElevatedButton(
            // onTap: _onHit,
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Palette.getButton()
                  .main
                  .withAlpha(widget.enabled ? 200 : 100)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
              padding: MaterialStateProperty.all(const EdgeInsets.all(13)),
            ),
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            )),
          )
        : ElevatedButton(
            // onTap: _onHit,
            onPressed: _onHit,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Palette.getButton()
                  .main
                  .withAlpha(widget.enabled ? 255 : 100)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
              padding: MaterialStateProperty.all(const EdgeInsets.all(18)),
            ),
            child: Center(
                child: Text(widget.text,
                    style: TextStyle(
                        fontSize: 18,
                        color: Palette.getButton().text,
                        fontWeight: FontWeight.bold))),
          );
  }

  void _onHit() {
    if (widget.callback != null) {
      widget.callback!();
    } else if (widget.asyncCallback != null) {
      setEnabled(false);
      widget.asyncCallback!().then((status) => setEnabled(true));
    }
  }

  void setEnabled(bool enabled) {
    setState(() {
      widget.enabled = enabled;
    });
  }
}

// ignore: must_be_immutable
class LinkMessage extends StatefulWidget {
  String message, link;
  late void Function() callback;
  double? fontSize;
  Color? color;
  bool enabled;

  LinkMessage(
    this.message,
    this.link,
    this.callback, {
    this.color,
    this.fontSize,
    super.key,
    this.enabled = true,
  });

  @override
  State<LinkMessage> createState() => _LinkMessageState();
}

class _LinkMessageState extends State<LinkMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.message,
            style: TextStyle(
                color: Palette.getLink().main,
                fontWeight: FontWeight.bold,
                fontSize: widget.fontSize)),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: !widget.enabled ? () {} : widget.callback,
          child: Text(widget.link,
              style: TextStyle(
                  color: (widget.color ?? Palette.getLink().text)
                      .withAlpha(widget.enabled ? 255 : 125),
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize)),
        )
      ],
    );
  }
}

class CardFormatter extends TextInputFormatter {
  final String sample;
  final String separator;

  CardFormatter({
    required this.sample,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var oldLength = oldValue.text.length;
    var newLength = newValue.text.length;
    if (newLength > 0) {
      if (newLength > oldLength) {
        if (newLength > sample.length) return oldValue;
        if (sample[newLength - 1] == separator) {
          return TextEditingValue(
              text:
                  '${oldValue.text}$separator${newValue.text.substring(newLength - 1)}',
              selection: TextSelection.collapsed(
                offset: newValue.selection.end + 1,
              ));
        }
      }
    }
    return newValue;
  }
}
