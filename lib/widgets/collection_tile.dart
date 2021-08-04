import 'package:flutter/material.dart';

class CollectionTile extends StatefulWidget {
  const CollectionTile();

  @override
  _CollectionTileState createState() => _CollectionTileState();
}

class _CollectionTileState extends State<CollectionTile> {
  static const IconData _TILE_ICON_WHEN_COLLAPSED = Icons.keyboard_arrow_right;
  static const IconData _TILE_ICON_WHEN_EXPANDED = Icons.keyboard_arrow_down;

  bool _expanded = false;
  IconData _tileIcon = _TILE_ICON_WHEN_COLLAPSED;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02),
                child: const Text("My collection"),
              ),
              ElevatedButton(
                onPressed: _processExpandPressed,
                child: Icon(_tileIcon),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                ),
              ),
            ],
          ),
        ),
        if (_expanded)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return const Text("Image here");
              },
            ),
          ),
      ],
    );
  }

  void _processExpandPressed() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _tileIcon = _TILE_ICON_WHEN_EXPANDED;
      } else {
        _tileIcon = _TILE_ICON_WHEN_COLLAPSED;
      }
    });
  }
}
