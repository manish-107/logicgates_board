import 'package:flutter/material.dart';

class DrageDropcard extends StatefulWidget {
  const DrageDropcard({super.key});

  @override
  State<DrageDropcard> createState() {
    return _DragDropState();
  }
}

class _DragDropState extends State<DrageDropcard> {
  String? droppedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Drag and Drop"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Draggable Widget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Draggable<String>(
                data: 'This is a draggable card',
                feedback: _buildCard("Dragging..."),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildCard("Drag me 1"),
                ),
                child: _buildCard("Drag me 1"),
              ),
              Draggable<String>(
                data: 'This is a draggable card 2',
                feedback: _buildCard("Dragging..."),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildCard("Drag me 2"),
                ),
                child: _buildCard("Drag me 2"),
              ),
              Draggable<String>(
                data: 'This is a draggable card 3',
                feedback: _buildCard("Dragging..."),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildCard("Drag me 3"),
                ),
                child: _buildCard("Drag me 3"),
              ),
              Draggable<String>(
                data: 'This is a draggable card 4',
                feedback: _buildCard("Dragging..."),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildCard("Drag me 4"),
                ),
                child: _buildCard("Drag me 4"),
              ),
            ],
          ),
          // DragTarget Widget
          DragTarget<String>(
            onAcceptWithDetails: (details) {
              // print('Accepted: ${details.data}');
              setState(() {
                droppedText = details.data;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                height: 250,
                width: 400,
                decoration: BoxDecoration(
                  color: candidateData.isEmpty
                      ? const Color.fromARGB(255, 215, 96, 81)
                      : Colors.blue.shade200,
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    droppedText ?? 'Drop here',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Card Widget
  Widget _buildCard(String text) {
    return Card(
      color: Colors.amber,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
