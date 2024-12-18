import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final bool isObscure;
  final bool numericKeyboard;
  final ValueChanged<String>? onChanged; // Nullable onChanged field
  final String errorText;
  final IconData? leftIcon;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    this.isObscure = false,
    this.numericKeyboard = false,
    this.onChanged,
    required this.errorText,
    this.leftIcon,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<TextFieldWidget> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isObscure;
  }

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align items to start
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.7)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (widget.leftIcon != null)
                Icon(
                  widget.leftIcon,
                  color: Colors.black.withOpacity(0.5),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  obscureText: _isObscured,
                  keyboardType: widget.numericKeyboard
                      ? TextInputType.phone
                      : TextInputType.text,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (widget.isObscure)
                IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: _toggleObscure,
                ),
            ],
          ),
        ),
        if (widget.errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
                top:
                    8.0), // Add some space between the field and the error text
            child: Text(
              widget.errorText,
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12), // Style for the error message
            ),
          ),
      ],
    );
  }
}
