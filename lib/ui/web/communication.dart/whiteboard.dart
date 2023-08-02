import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../utils/themes.dart';

class DrawingPoint {
  final String groupId;
  final double x;
  final double y;
  final int color;
  final double strokeWidth;

  DrawingPoint({
    required this.groupId,
    required this.x,
    required this.y,
    required this.color,
    required this.strokeWidth,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'x': x,
      'y': y,
      'color': color,
      'strokeWidth': strokeWidth,
    };
  }

  static DrawingPoint fromMap(Map<String, dynamic> map) {
    return DrawingPoint(
      groupId: map['groupId'] as String? ?? '',
      x: (map['x'] as num?)?.toDouble() ?? 0.0,
      y: (map['y'] as num?)?.toDouble() ?? 0.0,
      color: map['color'] as int? ?? 0,
      strokeWidth: (map['strokeWidth'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

class InteractiveWhiteboard extends StatefulWidget {
  const InteractiveWhiteboard({super.key});

  @override
  _InteractiveWhiteboardState createState() => _InteractiveWhiteboardState();
}

class _InteractiveWhiteboardState extends State<InteractiveWhiteboard> {
  final CollectionReference _drawingsCollection =
      FirebaseFirestore.instance.collection('drawings');

  Color _currentColor = Colors.black;
  double _currentBrushSize = 5.0;
  String _currentGroupId =
      DateTime.now().toString(); // Unique ID for each line.
  Offset? _lastRecordedPoint;

  Color _rulerColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorPrimary,
        title: const Text('Interactive Whiteboard'),
      ),
      body: CustomMultiChildLayout(
        delegate: WhiteboardLayoutDelegate(),
        children: [
          LayoutId(
            id: 'whiteboard',
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: StreamBuilder<QuerySnapshot>(
                stream: _drawingsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final drawings = snapshot.data!.docs
                      .map((doc) => DrawingPoint.fromMap(
                          doc.data() as Map<String, dynamic>))
                      .toList();

                  return CustomPaint(
                    painter:
                        WhiteboardPainter(drawings, rulerColor: _rulerColor),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.color_lens),
              onPressed: () => _showColorPicker(context),
            ),
            IconButton(
              icon: Icon(Icons.brush),
              onPressed: () => _showBrushSizePicker(context),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => _clearWhiteboard(),
            ),
            IconButton(
              icon: Icon(Icons.grid_on),
              onPressed: () => _toggleRulerGuide(),
              color: _rulerColor,
            ),
          ],
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.globalToLocal(details.globalPosition);

    // Record the initial point when the user starts drawing
    _lastRecordedPoint = offset;
  }

  void _onPanUpdate(DragUpdateDetails details) {
  RenderBox renderBox = context.findRenderObject() as RenderBox;
  final localOffset = renderBox.globalToLocal(details.globalPosition);

  if (_lastRecordedPoint == null) {
    // Record the initial point when the user starts drawing
    _lastRecordedPoint = localOffset;
    return;
  }

  // Calculate the distance between the current and last recorded points
  double distance = (localOffset - _lastRecordedPoint!).distance;

  if (distance > 2.0) {
    // Draw a straight line between the current and last recorded points
    int steps = (distance ~/ 2.0).toInt();
    double deltaX = (localOffset.dx - _lastRecordedPoint!.dx) / steps;
    double deltaY = (localOffset.dy - _lastRecordedPoint!.dy) / steps;

    for (int i = 0; i < steps; i++) {
      final data = DrawingPoint(
        groupId: _currentGroupId,
        x: _lastRecordedPoint!.dx + i * deltaX,
        y: _lastRecordedPoint!.dy + i * deltaY,
        color: _currentColor.value,
        strokeWidth: _currentBrushSize,
      );

      // Save the drawing data to Firebase.
      _drawingsCollection.add(data.toMap());
    }

    // Save the current point as the last recorded point for the next update
    _lastRecordedPoint = localOffset;
  }
}


  void _onPanEnd(DragEndDetails details) {
    // Reset the last recorded point when the user finishes drawing
    _lastRecordedPoint = null;
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (Color color) {
                setState(() => _currentColor = color);
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleRulerGuide() {
    setState(() {
      _rulerColor =
          _rulerColor == Colors.grey ? Colors.transparent : Colors.grey;
    });
  }

  void _showBrushSizePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Brush Size'),
          content: SingleChildScrollView(
            child: Slider(
              min: 1.0,
              max: 20.0,
              divisions: 19,
              value: _currentBrushSize,
              onChanged: (double value) {
                setState(() => _currentBrushSize = value);
              },
              label: _currentBrushSize.toString(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearWhiteboard() {
    // Clear the drawings from Firebase.
    _drawingsCollection.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}

class WhiteboardPainter extends CustomPainter {
  final List<DrawingPoint> drawings;
  final Color rulerColor;

  WhiteboardPainter(this.drawings, {required this.rulerColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the ruler guide lines
    if (rulerColor != Colors.transparent) {
      final paint = Paint()
        ..color = rulerColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.0;

      // Draw horizontal ruler lines
      for (double y = 0; y < size.height; y += 10) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }

      // Draw vertical ruler lines
      for (double x = 0; x < size.width; x += 10) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
    }

    // Draw user drawings on the canvas
    for (var drawing in drawings) {
      final groupId = drawing.groupId;
      final paint = Paint()
        ..color = Color(drawing.color)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = drawing.strokeWidth;

      if (drawing.x != null && drawing.y != null) {
        final currentOffset = Offset(drawing.x, drawing.y);
        canvas.drawPoints(PointMode.points, [currentOffset], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// New class to manage the layout of the whiteboard area.
class WhiteboardLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final whiteboardConstraints =
        BoxConstraints.tight(Size(size.width, size.height));
    layoutChild('whiteboard', whiteboardConstraints);
    positionChild('whiteboard', Offset.zero);
  }

  @override
  bool shouldRelayout(covariant WhiteboardLayoutDelegate oldDelegate) {
    return false;
  }
}
