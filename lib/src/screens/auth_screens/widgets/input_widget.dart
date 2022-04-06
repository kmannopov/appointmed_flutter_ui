import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function updateValue;
  final String hintText;
  final String? Function(String?)? validator;

  const InputWidget({
    Key? key,
    required this.controller,
    required this.updateValue,
    required this.hintText,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          TextFormField(
            //key: formKey,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text(hintText),
              alignLabelWithHint: true,
            ),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            controller: controller,
            validator: validator,
            onSaved: (value) {
              updateValue(value!);
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
