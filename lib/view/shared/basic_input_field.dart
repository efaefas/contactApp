import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_constants.dart';

class BasicInputField extends StatelessWidget {
  final Function? onChanged;
  final bool? enabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? text;
  final String? hint;
  final String? initialValue;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final bool obscureText;
  final int? lines;
  final Color? fillColor;
  final Color? enabledBorderColor;

  const BasicInputField(
      {super.key,
        this.onChanged,
        this.enabled = true,
        this.prefixIcon,
        this.suffixIcon,
        this.text,
        this.hint,
        this.lines,
        this.initialValue,
        this.textInputType,
        this.obscureText = false,
        this.controller,
        this.enabledBorderColor,
        this.fillColor
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (e) {
        if (onChanged != null) {
          onChanged!(e);
        }
      },
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      style: const TextStyle(fontSize: AppConstants.h7Size),
      enabled: enabled == true,
      initialValue: initialValue,
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      maxLines: lines ?? 1,
      inputFormatters: [
        textInputType == TextInputType.number
            ? FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            : FilteringTextInputFormatter.deny('[0-9]'),
      ],
      decoration: InputDecoration(
        labelText: text,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(width: 1.5, color: enabledBorderColor ?? Theme.of(context).primaryColorLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(width: 2.5, color: Theme.of(context).primaryColor),
        ),
        hintStyle: TextStyle(fontSize: AppConstants.h7Size, color: Colors.grey.shade500, letterSpacing: 0.5, fontWeight:  FontWeight.w400),
        labelStyle: TextStyle(fontSize: AppConstants.h7Size, color: Theme.of(context).primaryColor, letterSpacing: 0.5),
        floatingLabelStyle: TextStyle(color: Colors.grey.shade800),
        fillColor:  fillColor,
        alignLabelWithHint: true,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Theme.of(context).primaryColor,) : null,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppConstants.flexSchemeDark.primary,) : null,
      ),
    );
  }
}
