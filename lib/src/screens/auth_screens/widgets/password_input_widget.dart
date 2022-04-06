import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController passController;
  final TextEditingController confirmPassController;
  final Function updatePass;
  final Function updateConfirmPass;
  final String? Function(String?)? validator;
  final String? Function(String?)? confirmPassValidator;

  const PasswordInput(
      {Key? key,
      required this.validator,
      required this.confirmPassValidator,
      required this.passController,
      required this.confirmPassController,
      required this.updatePass,
      required this.updateConfirmPass})
      : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: const Text("Password*"),
                    alignLabelWithHint: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _visiblePassword = !_visiblePassword;
                          });
                        },
                        icon: Icon(_visiblePassword == false
                            ? Icons.visibility
                            : Icons.visibility_off))),
                obscureText: !_visiblePassword,
                obscuringCharacter: "\u2749",
                textInputAction: TextInputAction.next,
                controller: widget.passController,
                validator: widget.validator,
                onSaved: (value) {
                  widget.updatePass(value!);
                },
              ),
            ),
            const Spacer(),
            const Tooltip(
              message:
                  '\n\u2022 Include both lowercase and uppercase characters\n\u2022 Include atleast one number\n\u2022 Include atleast one special character\n\u2022 Be more than 6 characters long\n',
              triggerMode: TooltipTriggerMode.tap,
              showDuration: Duration(seconds: 5),
              preferBelow: false,
              child: Icon(
                Icons.info_outline,
                color: Colors.grey,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),

        //! Confirm Password
        TextFormField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: const Text("Confirm Password*"),
              alignLabelWithHint: true,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _visiblePassword = !_visiblePassword;
                    });
                  },
                  icon: Icon(_visiblePassword == false
                      ? Icons.visibility
                      : Icons.visibility_off))),
          obscureText: !_visiblePassword,
          textInputAction: TextInputAction.go,
          obscuringCharacter: "\u2749",
          controller: widget.confirmPassController,
          validator: widget.confirmPassValidator,
          onSaved: (value) {
            widget.updateConfirmPass(value!);
          },
        )
      ],
    );
  }
}
