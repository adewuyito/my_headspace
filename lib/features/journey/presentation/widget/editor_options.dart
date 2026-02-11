import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/note_colors.dart';

class EditorToolbar extends StatelessWidget {
  final QuillController controller;
  final ValueChanged<Color>? onColorChanged;
  final Color? activeColor;
  const EditorToolbar({
    super.key,
    required this.controller,
    this.onColorChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return QuillSimpleToolbar(
      controller: controller,
      config: QuillSimpleToolbarConfig(
        showBoldButton: true,
        showItalicButton: true,
        showColorButton: true,
        showListNumbers: true,
        showListBullets: true,
        showListCheck: true,
        showQuote: true,
        // Hide all other buttons
        showAlignmentButtons: false,
        showUnderLineButton: false,
        showStrikeThrough: false,
        showBackgroundColorButton: false,
        showClearFormat: false,
        showCodeBlock: false,
        showInlineCode: false,
        showLink: false,
        showIndent: false,
        showSearchButton: false,
        showSubscript: false,
        showSuperscript: false,
        showFontSize: false,
        showFontFamily: false,
        showHeaderStyle: false,
        showUndo: false,
        showRedo: false,
        buttonOptions: QuillSimpleToolbarButtonOptions(
          // ~ Custtom button configuration
          color: QuillToolbarColorButtonOptions(
            customOnPressedCallback: (controller, isPressed) async {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  final List<Color> colors = NoteColors.colorsList;
                  return Container(
                    height: 200.h,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                          ),
                      itemCount: colors.length,
                      itemBuilder: (BuildContext context, int index) {
                        final color = colors[index];
                        final isSelected = activeColor == color;
                        return GestureDetector(
                          onTap: () {
                            if (onColorChanged != null) {
                              onColorChanged!(color);
                            }
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected == true
                                  ? Colors.transparent
                                  : color,
                              border: isSelected == true
                                  ? BoxBorder.all(color: color, width: 2)
                                  : null,
                              shape: BoxShape.circle,
                            ),
                            child: isSelected == true
                                ? Icon(Icons.check, color: color)
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
