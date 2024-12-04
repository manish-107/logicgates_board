import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  const TextCard({super.key});

  @override
  Widget build(BuildContext context) {
    // BorderRadius.circular is not a const constructor, and therefore it cannot be used within a const
    return Card(
      color: const Color.fromARGB(2, 234, 211, 96),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
          padding: EdgeInsets.all(16),
          child: SelectableText(
            'You can now select this text by dragging your cursor!',
            style: TextStyle(fontSize: 18),
          )),
    );
  }
}
