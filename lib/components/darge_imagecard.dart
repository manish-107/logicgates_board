import 'package:flutter/material.dart';

class DargeImagecard extends StatefulWidget {
  const DargeImagecard({super.key});
  @override
  State<DargeImagecard> createState() {
    return _DragDropImageState();
  }
}

class _DragDropImageState extends State<DargeImagecard> {
  String? droppedImage;

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
                data: 'assets/images/itmanager.jpg',
                feedback: _buildImgCard('assets/images/itmanager.jpg'),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildImgCard('assets/images/itmanager.jpg'),
                ),
                child: _buildImgCard('assets/images/itmanager.jpg'),
              ),
              Draggable<String>(
                data: 'assets/images/webdev.jpg',
                feedback: _buildImgCard('assets/images/webdev.jpg'),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildImgCard('assets/images/webdev.jpg'),
                ),
                child: _buildImgCard('assets/images/webdev.jpg'),
              ),
              Draggable<String>(
                data: 'assets/images/reamenent.jpg',
                feedback: _buildImgCard('assets/images/reamenent.jpg'),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildImgCard("assets/images/reamenent.jpg"),
                ),
                child: _buildImgCard('assets/images/reamenent.jpg'),
              ),
              Draggable<String>(
                data: 'assets/images/vlogging.jpg',
                feedback: _buildImgCard('assets/images/vlogging.jpg'),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildImgCard('assets/images/vlogging.jpg'),
                ),
                child: _buildImgCard('assets/images/vlogging.jpg'),
              ),
            ],
          ),
          // DragTarget Widget
          DragTarget<String>(
            onAcceptWithDetails: (details) {
              // print('Accepted: ${details.data}');
              setState(() {
                droppedImage = details.data;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                  height: 400,
                  width: 1200,
                  decoration: BoxDecoration(
                    color: candidateData.isEmpty
                        ? const Color.fromARGB(255, 215, 96, 81)
                        : Colors.blue.shade200,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                      child: droppedImage != null
                          ? Image.asset(
                              droppedImage!,
                              // height: 200,
                              // width: 200,
                              // fit: BoxFit.cover,
                            )
                          : const Text(
                              'Drop an image here',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )));
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildImgCard(String imgurl) {
  return Card(
    color: Colors.amberAccent,
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          imgurl,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        )),
  );
}
