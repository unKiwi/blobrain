// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:adn2/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PionSelector extends StatefulWidget {
  @override
  _PionSelector createState() => _PionSelector();
}

class _PionSelector extends State<PionSelector> {
  late List<Widget> _childrenColor;
  late List<Widget> _childrenShape;

  @override
  void initState() {
    update();
    super.initState();
  }

  void update() {
    _childrenColor = [];
    _childrenShape = [];

    _childrenColor.add(
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            primary: Colors.transparent,
            shadowColor: Colors.transparent
          ),
          onPressed: () {
            Data.currentColor = 0;
            update();
          },
          child: FractionallySizedBox(
            heightFactor: 0.9,
            widthFactor: 0.9,
            child: SvgPicture.asset(
              "assets/shapes/${Data.lsShape[Data.currentShape]}/#313954.svg",
            ),
          ),
        ),
      ),
    );
    _childrenShape.add(
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            primary: Colors.transparent,
            shadowColor: Colors.transparent
          ),
          onPressed: () {
            Data.currentShape = 0;
            update();
          },
          child: FractionallySizedBox(
            heightFactor: 0.9,
            widthFactor: 0.9,
            child: SvgPicture.asset(
              "assets/shapes/shape/${Data.lsColor[Data.currentColor]}.svg",
            ),
          ),
        ),
      ),
    );

    // fill _childrenColor and _childrenShape
    for (int i = 1; i <= Data.cote; i++) {
      _childrenColor.add(
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              Data.currentColor = i;
              update();
            },
            child: FractionallySizedBox(
              heightFactor: 0.9,
              widthFactor: 0.9,
              child: SvgPicture.asset(
                "assets/shapes/${Data.lsShape[Data.currentShape]}/${Data.lsColor[i]}.svg",
              ),
            ),
          ),
        ),
      );
      _childrenShape.add(
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              Data.currentShape = i;
              update();
            },
            child: FractionallySizedBox(
              heightFactor: 0.9,
              widthFactor: 0.9,
              child: SvgPicture.asset(
                "assets/shapes/${Data.lsShape[i]}/${Data.lsColor[Data.currentColor]}.svg",
              ),
            ),
          ),
        ),
      );
    }

    setState(() {
      _childrenColor;
      _childrenShape;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: AspectRatio(
        aspectRatio: (Data.cote + 1) / 2,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double _radius = constraints.maxHeight / 10;
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.all(Radius.circular(_radius)),
                border: Border.all(
                  color: Colors.white70,
                  width: constraints.maxHeight / 50,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: _childrenColor,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: _childrenShape,
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}