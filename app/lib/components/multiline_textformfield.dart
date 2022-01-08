import 'package:app/constants/constants.dart';
import 'package:app/constants/txt_style_constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  String hintText;
  Function onChanged;
  TextInputType textInputType;
  bool obscureText;
  double width;
  Function validator;
  TextEditingController controller;

  CustomTextFormField(
      {this.hintText,
      this.onChanged,
      this.textInputType,
      this.obscureText,
      this.width,
      this.validator,
      this.controller});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width == null
          ? MediaQuery.of(context).size.width
          : widget.width,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 140.0,
        child: TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: null,
          obscureText: widget.obscureText == null ? false : widget.obscureText,
          //textAlign: TextAlign.center,
          onChanged: widget.onChanged,
          style: "$_value".isEmpty
              ? kUnderlineTextFieldTextStyle
              : kUnderlineTextFieldFilledTextStyle,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: kHhintTextComment,
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}
