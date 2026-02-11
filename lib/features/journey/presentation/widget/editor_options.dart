import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditorToolbar extends StatelessWidget {
  final QuillController controller;
  final ValueChanged<Color>? onColorChanged;
  const EditorToolbar({
    super.key,
    required this.controller,
    this.onColorChanged,
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
                  final List<Color> colors = [
                    Color(0xFFFAFAFA), // ~ White
                    Color(0xFFFEF1CF),
                    Color(0xFFDBEFF2),
                    Color(0xFFBFD4FB),
                    Color(0xFFFFADAD),
                    Color(0xFFFCA1F6),
                    Color(0xFFBEE9C2),
                    Color(0xFFCDCDCD),
                    Color(0xFFD0BDFF),
                    Color(0xFFFF6600),
                  ];
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
                              color: color,
                              shape: BoxShape.circle,
                            ),
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
