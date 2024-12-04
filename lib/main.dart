import 'package:flutter/material.dart';
// import 'components/text_card.dart';
// import 'components/draggable_card.dart';
// import 'components/drage_dropcard.dart';
// import 'components/darge_imagecard.dart';
// import 'components/darge_placecard.dart';
// import 'components/drage_linejoin.dart';
import 'components/gates_links.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      title: 'flutter app',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GatesLinks();
  }
}
