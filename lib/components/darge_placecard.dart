import 'package:flutter/material.dart';

class DargePlacecard extends StatefulWidget {
  const DargePlacecard({super.key});

  @override
  State<DargePlacecard> createState() => _DragDropImageState();
}

class _DragDropImageState extends State<DargePlacecard> {
  List<Map<String, dynamic>> droppedImage = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("drag and place image"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPlaceImgCard('assets/images/itmanager.jpg'),
              _buildPlaceImgCard('assets/images/itmanager.jpg'),
              _buildPlaceImgCard('assets/images/itmanager.jpg'),
            ],
          ),
          Expanded(
            child: DragTarget<Map<String, dynamic>>(
              onAcceptWithDetails: (details) {
                final localPosition = details.offset;

                setState(() {
                  droppedImage.add({
                    'path': details.data['path'],
                    'position': Offset(
                      localPosition.dx - 50,
                      localPosition.dy - 150,
                    ),
                  });
                  print(droppedImage);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: double.infinity,
                  color: Colors.amberAccent,
                  child: Stack(
                    children: [
                      for (var image in droppedImage)
                        Positioned(
                          left: image['position'].dx,
                          top: image['position'].dy,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                image['position'] = Offset(
                                  image['position'].dx + details.delta.dx,
                                  image['position'].dy + details.delta.dy,
                                );
                              });
                            },
                            child: Image.asset(
                              image['path'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaceImgCard(String path) {
    return Draggable<Map<String, dynamic>>(
      data: {'path': path},
      feedback: Image.asset(
        path,
        height: 100,
        width: 100,
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
}
