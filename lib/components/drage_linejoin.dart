import 'package:flutter/material.dart';

class DrageLinejoin extends StatefulWidget {
  const DrageLinejoin({super.key});

  @override
  State<DrageLinejoin> createState() => _DragDropLineState();
}

class _DragDropLineState extends State<DrageLinejoin> {
  List<Map<String, dynamic>> droppedImage = [];
  Map<int, List<int>> lineCardsAxis = {};
  List<int> twoCardsToJoin = [];
  bool allowdrawLine = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drag, Drop and Draw Line Between Images"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPlaceImgCard('assets/gates/notgate.png'),
              _buildPlaceImgCard('assets/gates/orgate.png'),
              _buildPlaceImgCard('assets/gates/andgate.png'),
              ElevatedButton(
                onPressed: () {
                  _onClickbuttn();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: allowdrawLine ? Colors.red : Colors.green,
                ),
                child: Text(
                    allowdrawLine ? "Tap on  Image" : "Toggle Line Drawing"),
              ),
            ],
          ),
          Expanded(
            child: DragTarget<Map<String, dynamic>>(
              onAcceptWithDetails: (details) {
                final localPosition = details.offset;

                setState(() {
                  droppedImage.add({
                    'id': droppedImage.length + 1,
                    'path': details.data['path'],
                    'position':
                        Offset(localPosition.dx - 50, localPosition.dy - 150),
                  });

                  print('droppedImage: $droppedImage');
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: double.maxFinite,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          // Draw the lines in the background
                          for (var entry in lineCardsAxis.entries)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: LinePrinter(
                                  start: droppedImage.firstWhere((img) =>
                                      img['id'] == entry.value[0])['position'],
                                  end: droppedImage.firstWhere((img) =>
                                      img['id'] == entry.value[1])['position'],
                                ),
                              ),
                            ),

                          // Position the images and allow them to be dragged
                          for (var image in droppedImage)
                            Positioned(
                              left: image['position'].dx,
                              top: image['position'].dy,
                              child: GestureDetector(
                                onTap: () {
                                  if (allowdrawLine) {
                                    // If allowdrawLine is true, add the id of the image to twoCardsToJoin
                                    setState(() {
                                      if (twoCardsToJoin.length < 2) {
                                        twoCardsToJoin.add(image['id']);
                                      }

                                      print('twoCardsToJoin: $twoCardsToJoin');

                                      if (twoCardsToJoin.length == 2) {
                                        // Create a new connection in lineCardsAxis
                                        lineCardsAxis[
                                            lineCardsAxis.length + 1] = [
                                          twoCardsToJoin[0],
                                          twoCardsToJoin[1]
                                        ];

                                        twoCardsToJoin.clear();

                                        print(
                                            'Updated lineCardsAxis: $lineCardsAxis');
                                      }
                                    });
                                  }
                                },
                                onPanUpdate: (details) {
                                  setState(() {
                                    print('details $details');
                                    image['position'] = Offset(
                                      image['position'].dx + details.delta.dx,
                                      image['position'].dy + details.delta.dy,
                                    );

                                    // If this image is part of the selected pair, update the corresponding line
                                    lineCardsAxis
                                        .forEach((lineId, connectedIds) {
                                      if (connectedIds.contains(image['id'])) {
                                        var otherImageId =
                                            connectedIds.firstWhere(
                                                (id) => id != image['id']);
                                        var otherImage =
                                            droppedImage.firstWhere((img) =>
                                                img['id'] == otherImageId);

                                        // Update the line's start or end position
                                        setState(() {
                                          // Update the line's coordinates for this connection
                                          lineCardsAxis[lineId] = [
                                            image['id'],
                                            otherImage['id']
                                          ];
                                        });
                                      }
                                    });
                                  });
                                },
                                child: Image.asset(
                                  image['path'],
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onClickbuttn() {
    setState(() {
      allowdrawLine = !allowdrawLine;
    });

    // Log the value of allowdrawLine after toggling
    print('allowdrawLine: $allowdrawLine');
  }
}

class LinePrinter extends CustomPainter {
  Offset start;
  Offset end;

  LinePrinter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Adjust the start and end positions to connect the centers of the images
    canvas.drawLine(
      Offset(start.dx + 50,
          start.dy + 50), // Adjust for the center of the start image
      Offset(
          end.dx + 50, end.dy + 50), // Adjust for the center of the end image
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever the offsets or properties change
  }
}

Widget _buildPlaceImgCard(String path) {
  return Draggable<Map<String, dynamic>>(
    data: {'path': path},
    feedback: Padding(
      padding: const EdgeInsets.all(2),
      child: Image.asset(
        path,
        width: 100,
        height: 100,
      ),
    ),
    childWhenDragging: Opacity(
      opacity: 0.5,
      child: Image.asset(
        path,
        width: 100,
        height: 100,
      ),
    ),
    child: Image.asset(
      path,
      height: 100,
      width: 100,
    ),
  );
}
