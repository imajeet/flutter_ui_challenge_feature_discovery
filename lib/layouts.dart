import 'package:flutter/widgets.dart';

class OverlayBuilder extends StatefulWidget {

  final bool showOverlay;
  final Widget Function(BuildContext) overlayBuilder;
  final Widget child;

  OverlayBuilder({
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  });

  @override
  _OverlayBuilderState createState() => new _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {

  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncWidgetAndOverlay();
  }


  @override
  void reassemble() {
    super.reassemble();
    syncWidgetAndOverlay();
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = new OverlayEntry(
      builder: widget.overlayBuilder,
    );
    addToOverlay(overlayEntry);
  }

  void addToOverlay(OverlayEntry entry) async {
    Overlay.of(context).insert(entry);
  }

  void hideOverlay() {
    overlayEntry.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

}


class CenterAbout extends StatelessWidget {

  final Offset position;
  final Widget child;

  CenterAbout({
    this.position,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: position.dx,
      top: position.dy,
      child: new FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}

class AnchoredOverlay extends StatelessWidget {

  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  AnchoredOverlay({
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return new OverlayBuilder(
            showOverlay: showOverlay,

            overlayBuilder: (BuildContext overlayContext) {
              RenderBox box = context.findRenderObject() as RenderBox;
              final center = box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));

              return overlayBuilder(overlayContext, center);
            },

            child: child,
          );
        },
      ),
    );
  }
}
