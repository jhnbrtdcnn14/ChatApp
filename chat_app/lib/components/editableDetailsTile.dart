import 'package:chat_app/components/colors.dart';
import 'package:chat_app/components/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditableDetailsTile extends StatefulWidget {
  final String title;
  final String detail;
  final Function(String) onSave;

  EditableDetailsTile({
    required this.title,
    required this.detail,
    required this.onSave,
  });

  @override
  _EditableDetailsTileState createState() => _EditableDetailsTileState();
}

class _EditableDetailsTileState extends State<EditableDetailsTile> {
  bool isEditing = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.detail;
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
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              AppText(
                text: widget.title,
                size: 18,
                color: AppColors.darkgrey,
                isBold: true,
              ),
              Gap(20),
              Expanded(
                child: isEditing
                    ? TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: widget.detail,
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          widget.onSave(value);
                          setState(() {
                            isEditing = false;
                          });
                        },
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            isEditing = true;
                            _controller.text = widget.detail;
                          });
                        },
                        child: Text(widget.detail),
                      ),
              ),
            ],
          ),
        ),
        Gap(20)
      ],
    );
  }
}
