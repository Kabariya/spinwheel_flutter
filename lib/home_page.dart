import 'dart:math';

import 'package:flutter/material.dart';

import 'board_view.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  ValueNotifier<int> finalValue = ValueNotifier(-1);
  AnimationController _ctrl;
  Animation _ani;
  List<Luck> _items = [
    Luck("coin", Color(0xffFCEAD6), 10),
    Luck("coin_few", Color(0xffFCDCB4), 30),
    Luck("coin_more", Color(0xffFCEAD6), 20),
    Luck("coin", Color(0xffFCDCB4), 10),
    Luck("coin_few", Color(0xffFCEAD6), 30),
    Luck("coin_more", Color(0xffFCDCB4), 100),
    Luck("coin_few", Color(0xffFCEAD6), 20),
    Luck("coin_more", Color(0xffFCDCB4), 50),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var _duration = Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn)
      ..addListener(() {
        if (_ani.isCompleted) {
          var _index = _calIndex(_ani.value * _angle + _current);
          int finalResult = _items[_index].value;
          print("FINAL VALUE -- > $finalResult");
          finalValue.value = finalResult;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green, Colors.blue.withOpacity(0.2)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: finalValue,
                builder: (context, value, child) {
                  return Text("${(finalValue.value != -1) ? '${finalValue.value}' : ""}", style: TextStyle(fontSize: 50, color: Colors.white),);
                }),
            AnimatedBuilder(
                animation: _ani,
                builder: (context, child) {
                  final _value = _ani.value;
                  final _angle = _value * this._angle;
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      BoardView(
                          items: _items, current: _current, angle: _angle),
                      _buildGo(),
                      // _buildResult(_value),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  _buildGo() {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        child: SizedBox(
          child: Image.asset('asset/image/go_button.png'),
          width: 55,
          height: 55,
        ),
        onTap: _animation,
      ),
    );
  }

  _animation() {
    if (!_ctrl.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();
      });
    }
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }

  _buildResult(_value) {
    var _index = _calIndex(_value * _angle + _current);
    int _asset = _items[_index].value;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text("$_asset"),
      ),
    );
  }
}
