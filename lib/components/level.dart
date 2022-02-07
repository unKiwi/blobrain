// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:adn2/data/data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Level extends StatefulWidget {
  @override
  _Level createState() => _Level();
}

class _Level extends State<Level> {
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          showLabels: false,
          showTicks: false,
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 100,
          radiusFactor: 0.8,
          axisLineStyle: AxisLineStyle(
            thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15
          ),
          annotations: [
            GaugeAnnotation(
              angle: 180,
              widget: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 0.5,
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      double _translation = constraints.maxWidth / 20;

                      return Transform.translate(
                        offset: Offset(-_translation, 0),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "${Data.level}",
                              style: TextStyle(
                                fontSize: 500,
                              ),
                            ),
                          )
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
          ],
          pointers: [
            RangePointer(
                value: Data.percent,
                cornerStyle: CornerStyle.bothCurve,
                enableAnimation: true,
                animationDuration: 1200,
                animationType: AnimationType.ease,
                sizeUnit: GaugeSizeUnit.factor,
                gradient: SweepGradient(
                    colors: <Color>[Color(0xFF6A6EF6), Color(0xFFDB82F5)],
                    stops: <double>[0.25, 0.75]),
                color: Color(0xFF00A8B5),
                width: 0.15),
          ]
        ),
      ],
    );
  }
}