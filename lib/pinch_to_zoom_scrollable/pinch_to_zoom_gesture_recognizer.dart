import 'package:flutter/gestures.dart';

class PinchToZoomGestureRecognizer extends OneSequenceGestureRecognizer {
  final void Function() onScaleStart;
  final void Function() onScaleUpdate;
  final void Function() onScaleEnd;

  PinchToZoomGestureRecognizer({
    required this.onScaleStart,
    required this.onScaleUpdate,
    required this.onScaleEnd,
  });

  @override
  String get debugDescription => '$runtimeType';

  Map<int, Offset> pointerPositionMap = {};

  @override
  void addAllowedPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
    pointerPositionMap[event.pointer] = event.position;
    if (pointerPositionMap.length >= 2) {
      resolve(GestureDisposition.accepted);
    }
  }
  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      pointerPositionMap[event.pointer] = event.position;
      return;
    } else if (event is PointerDownEvent) {
      pointerPositionMap[event.pointer] = event.position;
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      stopTrackingPointer(event.pointer);
      pointerPositionMap.remove(event.pointer);
    }

    if (pointerPositionMap.length >= 2) {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    resolve(GestureDisposition.rejected);
  }
}