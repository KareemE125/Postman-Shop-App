import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget {
  final textInputType;
  final maxLength;
  final textInputAction;
  final prefixIcon;
  final labelText;
  final isObscure;
  final validatorFunction;
  final onSavedFunction;
  final onFieldSubmittedFunction;
  final onChangedFunction;

  DefaultTextFormField({
    @required this.textInputType,
    this.maxLength,
    @required this.textInputAction,
    @required this.prefixIcon,
    @required this.labelText,
    this.isObscure = false,
    @required this.validatorFunction,
    @required this.onSavedFunction,
    this.onFieldSubmittedFunction,
    this.onChangedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      obscureText: isObscure,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Theme.of(context).primaryColorLight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Theme.of(context).primaryColorDark,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        prefixIcon: Icon(prefixIcon),
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.white38
        //helperText: helperTextName,
      ),
      autocorrect: false,
      onChanged: onChangedFunction,
      onFieldSubmitted: onFieldSubmittedFunction,
      validator: validatorFunction,
      onSaved: onSavedFunction,
    );
  }
}
