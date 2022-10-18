import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable/pinch_to_zoom_scroll_view.dart';

void main() {
  debugPrintGestureArenaDiagnostics = true;
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinchToZoomScrollView(
        initialSize: 5000,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              20,
                  (index) => Text("Item $index"),
            ),
          ),
        ),
      ),
    );
  }
}