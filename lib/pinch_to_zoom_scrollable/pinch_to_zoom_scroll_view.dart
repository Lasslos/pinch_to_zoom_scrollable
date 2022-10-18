import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable/pinch_to_zoom_gesture_recognizer.dart';
import 'single_pointer_single_child_scroll_view.dart';

class PinchToZoomScrollView extends StatelessWidget {
  ///See [SingleChildScrollView] for more details on this property.
  final Axis scrollDirection;
  ///See [SingleChildScrollView] for more details on this property.
  final bool reverse;
  ///See [SingleChildScrollView] for more details on this property.
  final EdgeInsetsGeometry? padding;
  ///See [SingleChildScrollView] for more details on this property.
  final bool? primary;
  ///See [SingleChildScrollView] for more details on this property.
  final ScrollPhysics? physics;
  ///See [SingleChildScrollView] for more details on this property.
  final ScrollController? controller;
  ///See [SingleChildScrollView] for more details on this property.
  final DragStartBehavior dragStartBehavior;
  ///See [SingleChildScrollView] for more details on this property.
  final Clip clipBehavior;
  ///See [SingleChildScrollView] for more details on this property.
  final String? restorationId;
  ///See [SingleChildScrollView] for more details on this property.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  PinchToZoomScrollView({
    required this.child,
    required this.initialSize,
    super.key,
    this.minimumSize,
    this.maximumSize,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.padding,
    this.primary,
    this.physics,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  }) :
    assert(
      initialSize >= (minimumSize ?? initialSize),
      'initialSize must be greater than minimumSize',
    ),
    assert(
      initialSize <= (maximumSize ?? initialSize),
      'initialSize must be less than maximumSize',
    ),
    assert(
      (minimumSize ?? initialSize) <= (maximumSize ?? initialSize),
      'minimumSize must be less than maximumSize',
    );

  final double initialSize;
  ///The minimum size. 0 if not given
  final double? minimumSize;
  ///The maximum size. Infinity if not given
  final double? maximumSize;

  final Widget child;

  final GlobalKey<_ChangeableSizeWidgetState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SinglePointerSingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      primary: primary,
      physics: physics,
      controller: controller,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      child: RawGestureDetector(
        behavior: HitTestBehavior.translucent,
        gestures: <Type, GestureRecognizerFactory>{
          PinchToZoomGestureRecognizer: GestureRecognizerFactoryWithHandlers<PinchToZoomGestureRecognizer>(
            () => PinchToZoomGestureRecognizer(
              onScaleStart: () {},
              onScaleUpdate: () {},
              onScaleEnd: () {},
            ),
            (instance) {},
          ),
        },
        child: _ChangeableSizeWidget(
          key: _key,
          direction: scrollDirection,
          minSize: minimumSize ?? 0,
          maxSize: maximumSize ?? double.infinity,
          initialSize: initialSize,
          child: child,
        ),
      ),
    );
  }
}

class _ChangeableSizeWidget extends StatefulWidget {
  const _ChangeableSizeWidget({
    required this.direction,
    required this.initialSize,
    required this.minSize,
    required this.maxSize,
    required this.child,
    super.key,
  });

  final Axis direction;
  final double initialSize;
  final double maxSize;
  final double minSize;
  final Widget child;

  @override
  State<_ChangeableSizeWidget> createState() =>
      _ChangeableSizeWidgetState();
}

class _ChangeableSizeWidgetState extends State<_ChangeableSizeWidget> {
  late double _size;

  double get size => _size;

  set size(double value) {
    setState(() {
      _size = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _size = widget.initialSize;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.direction == Axis.horizontal ? _size : null,
    height: widget.direction == Axis.vertical ? _size : null,
    child: widget.child,
  );
}
