import 'package:flutter/material.dart';

class DraggableCard extends StatelessWidget {
  const DraggableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: 'CardData',
      feedback: Material(
        color: Colors.transparent,
        child: _buildcard(),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildcard(),
      ),
      child: _buildcard(),
    );
  }

  Widget _buildcard() {
    return Card(
      color: const Color.fromARGB(7, 227, 227, 105),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text("text inside card"),
      ),
    );
  }
}
