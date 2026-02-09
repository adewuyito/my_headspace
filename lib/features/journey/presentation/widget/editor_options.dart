import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorToolbar extends StatelessWidget {
  final QuillController controller;
  const EditorToolbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return QuillSimpleToolbar(
      controller: controller,
      config: const QuillSimpleToolbarConfig(
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
          color: QuillToolbarColorButtonOptions(),
        ),
      ),
    );
  }
}
