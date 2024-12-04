import 'package:flutter/material.dart';
import '../gatescomponents/diloag_box.dart';

class GatesLinks extends StatefulWidget {
  const GatesLinks({super.key});

  @override
  State<GatesLinks> createState() => _GatesDrawLines();
}

class _GatesDrawLines extends State<GatesLinks> {
  List<Map<String, dynamic>> droppedImage = [];
  Map<int, List<int>> lineCardsAxis = {};
  List<int> twoCardsToJoin = [];
  bool allowdrawLine = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gates design"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildImgCard('assets/gates/notgate.png'),
              _buildImgCard('assets/gates/orgate.png'),
              _buildImgCard('assets/gates/andgate.png'),
              ElevatedButton(
                onPressed: () {
                  _onClickbuttn();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: allowdrawLine ? Colors.red : Colors.green,
                ),
                child: Text(
                    allowdrawLine ? "Tap on Image" : "Toggle Line Drawing"),
              ),
            ],
          ),
          Expanded(
            child: DragTarget<Map<String, dynamic>>(
              onAcceptWithDetails: (details) async {
                final localPosition = details.offset;
                final int? noOfNodes =
                    await DiloagBox.getNumberOfNoders(context);

                if (noOfNodes == null || noOfNodes < 1) {
                  return;
                }

                setState(() {
                  droppedImage.add({
                    'id': droppedImage.length + 1,
                    'path': details.data['path'],
                    'position':
                        Offset(localPosition.dx - 50, localPosition.dy - 150),
                    'noOfNodes':
                        details.data['path'] == "assets/gates/notgate.png"
                            ? 1
                            : noOfNodes,
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
                                start: Offset(
                                  droppedImage
                                          .firstWhere(
                                            (img) =>
                                                img['id'] == entry.value[0],
                                            orElse: () =>
                                                {'position': Offset.zero},
                                          )['position']
                                          .dx +
                                      114, // Increase X by 20
                                  droppedImage
                                          .firstWhere(
                                            (img) =>
                                                img['id'] == entry.value[0],
                                            orElse: () =>
                                                {'position': Offset.zero},
                                          )['position']
                                          .dy +
                                      5, // Keep Y as it is
                                ),
                                end: updateEndPosition(
                                  droppedImage.firstWhere(
                                    (img) => img['id'] == entry.value[1],
                                    orElse: () => {'position': Offset.zero},
                                  )['position'],
                                  entry.value[2],
                                  entry.value[1],
                                ),
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
                                  setState(() {
                                    if (twoCardsToJoin.length < 2) {
                                      twoCardsToJoin.add(image['id']);
                                    }

                                    if (twoCardsToJoin.length == 2) {
                                      lineCardsAxis[lineCardsAxis.length + 1] =
                                          [
                                        twoCardsToJoin[0],
                                        twoCardsToJoin[1],
                                      ];
                                      twoCardsToJoin.clear();
                                      allowdrawLine = !allowdrawLine;
                                      print(twoCardsToJoin);
                                      print(allowdrawLine);
                                    }
                                  });
                                }
                              },
                              onPanUpdate: (details) {
                                setState(() {
                                  image['position'] = Offset(
                                    image['position'].dx + details.delta.dx,
                                    image['position'].dy + details.delta.dy,
                                  );

                                  lineCardsAxis.forEach((lineId, connectedIds) {
                                    if (connectedIds.contains(image['id'])) {
                                      var otherImageId =
                                          connectedIds.firstWhere(
                                              (id) => id != image['id']);
                                      var otherImage = droppedImage.firstWhere(
                                          (img) => img['id'] == otherImageId);

                                      Offset startPosition = Offset(
                                        droppedImage
                                                .firstWhere((img) =>
                                                    img['id'] ==
                                                    connectedIds[0])['position']
                                                .dx +
                                            114,
                                        droppedImage
                                                .firstWhere((img) =>
                                                    img['id'] ==
                                                    connectedIds[0])['position']
                                                .dy +
                                            5,
                                      );

                                      Offset endPosition = updateEndPosition(
                                        droppedImage.firstWhere((img) =>
                                            img['id'] ==
                                            connectedIds[1])['position'],
                                        connectedIds.length > 2
                                            ? connectedIds[2]
                                            : null,
                                        connectedIds[1],
                                      );

                                      lineCardsAxis[lineId] = [
                                        connectedIds[0],
                                        connectedIds[1],
                                        if (connectedIds.length > 2)
                                          connectedIds[2]
                                      ];
                                    }
                                  });
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (image['noOfNodes'] != null &&
                                      image['noOfNodes'] > 0)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        image['noOfNodes'],
                                        (index) => GestureDetector(
                                          onTap: () {
                                            if (allowdrawLine) {
                                              setState(() {
                                                if (twoCardsToJoin.length < 2) {
                                                  twoCardsToJoin
                                                      .add(image['id']);
                                                }

                                                if (twoCardsToJoin.length ==
                                                    2) {
                                                  lineCardsAxis[
                                                      lineCardsAxis.length +
                                                          1] = [
                                                    twoCardsToJoin[0],
                                                    twoCardsToJoin[1],
                                                    index + 1
                                                  ];
                                                  print(lineCardsAxis);
                                                  twoCardsToJoin.clear();
                                                }
                                              });
                                            }
                                          },
                                          child: Image.asset(
                                            'assets/gates/node.png',
                                            width: 50,
                                            height: image['noOfNodes'] == 2
                                                ? 40
                                                : image['noOfNodes'] == 3
                                                    ? 20
                                                    : image['noOfNodes'] == 4
                                                        ? 15
                                                        : 10,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                      width: 5), // Adjust spacing if necessary
                                  Image.asset(
                                    image['path'],
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Offset updateEndPosition(Offset end, dynamic nodeplace, dynamic secondgate) {
    var gate = droppedImage.firstWhere((gate) => gate['id'] == secondgate);

    int noOfNodes = gate['noOfNodes'] ?? 0;

    double nodeSpacing = 12.0;

    if (noOfNodes == 2) {
      nodeSpacing = 36.0;
    } else if (noOfNodes == 3) {
      nodeSpacing = 20.0;
    } else if (noOfNodes == 4) {
      nodeSpacing = 12.0;
    } else {
      nodeSpacing = 10.0;
    }

    double nodeOffsetY = (nodeplace - 1) * nodeSpacing;

    double updatedEndX = end.dx - 50;
    double updatedEndY = end.dy - 13 + nodeOffsetY;

    return Offset(updatedEndX, updatedEndY);
  }

  void _onClickbuttn() {
    setState(() {
      allowdrawLine = !allowdrawLine;
    });

    print('allowdrawLine: $allowdrawLine');
  }
}

class LinePrinter extends CustomPainter {
  Offset start;
  Offset end;

  LinePrinter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    print('$start and $end');
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(start.dx + 50, start.dy + 50),
      Offset(end.dx + 50, end.dy + 50),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Widget _buildImgCard(String path) {
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
