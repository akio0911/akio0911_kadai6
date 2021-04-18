import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _answerValue = _makeAnswerValue();
  int _sliderValue = _initialValue;

  static final _minValue = 1;
  static final _maxValue = 100;
  static final _initialValue = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$_answerValue'),
            _buildSliderAndMinMaxText(),
            _buildJudgmentButton(context: context),
          ],
        ),
      ),
    );
  }

  static int _makeAnswerValue() {
    return Random().nextInt(_maxValue - _minValue + 1) + _minValue;
  }

  Widget _buildSlider() {
    return Slider(
      value: _sliderValue.toDouble(),
      min: _minValue.toDouble(),
      max: _maxValue.toDouble(),
      onChanged: (double value) {
        setState(() {
          _sliderValue = value.toInt();
        });
      },
    );
  }

  Widget _buildSliderAndMinMaxText() {
    return Column(
      children: [
        _buildSlider(),
        Row(
          children: [
            SizedBox(width: 32),
            Text('$_minValue'),
            Expanded(child: Container()),
            Text('$_maxValue'),
            SizedBox(width: 32),
          ],
        ),
      ],
    );
  }

  Widget _buildJudgmentButton({BuildContext context}) {
    return TextButton(
        onPressed: () {
          final firstLine = _sliderValue.toInt() == _answerValue ? 'あたり！' : '外れ...';
          final message = '''
          $firstLine
          あなたの値: ${_sliderValue.toInt()}''';

          _showDialog(
            context: context,
            message: message,
            buttonText: '再挑戦',
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                _answerValue = _makeAnswerValue();
                _sliderValue = _initialValue;
              });
            }
          );
        },
        child: Text('判定！', style: TextStyle(color: Colors.blue))
    );
  }

  void _showDialog({BuildContext context, String message, String buttonText, void Function() onPressed}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: (){
                onPressed();
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
