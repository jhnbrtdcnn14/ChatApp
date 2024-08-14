import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class EditableDetailsTile extends StatefulWidget {
  final String title;
  final String detail;
  bool isEditable;
  final Function(String) onSave;

  EditableDetailsTile({
    super.key,
    required this.title,
    required this.detail,
    this.isEditable = false,
    required this.onSave,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditableDetailsTileState createState() => _EditableDetailsTileState();
}

class _EditableDetailsTileState extends State<EditableDetailsTile> {
  final TextEditingController _controller = TextEditingController();
  late bool isEditable;

  @override
  void initState() {
    _controller.text = widget.detail;
    isEditable = widget.isEditable;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              AppText(
                text: widget.title,
                size: 18,
                color: AppColors.blue,
                isBold: true,
              ),
              const Gap(20),
              Expanded(
                child: isEditable
                    ? TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: widget.detail,
                          border: const OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          widget.onSave(value);
                          setState(() {
                            isEditable = false;
                          });
                        },
                      )
                    : InkWell(
                        onTap: () {
                          if (isEditable) {
                            setState(() {
                              isEditable = true;
                              _controller.text = widget.detail;
                            });
                          }
                        },
                        child: Text(widget.detail),
                      ),
              ),
            ],
          ),
        ),
        const Gap(20)
      ],
    );
  }
}
