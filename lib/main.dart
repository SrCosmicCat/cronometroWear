import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

//*  Cronometro
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return AmbientMode(
      child: const WatchScreen(),
      builder: (context, mode, child){
        return MaterialApp(
          title: 'Timer',
          theme: ThemeData(
            visualDensity: VisualDensity.compact,
            fontFamily: 'Varela',
            colorScheme: mode == WearMode.active
              ? const ColorScheme.dark(
                  primary: Color.fromARGB(255, 227, 41, 103),
                  secondary: Color.fromARGB(255, 224, 224, 224),
                  background: Color.fromARGB(255, 15, 15, 16),
                )
              : const ColorScheme.dark(
                  primary: Color.fromARGB(255, 67, 66, 67),
                  secondary: Color.fromARGB(255, 67, 66, 67),
                  background: Color.fromARGB(255, 15, 15, 16),
                )
          ),
          home: child,
        );
      }
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TimerScreen(theme);
  }
}

class TimerScreen extends StatefulWidget {
  final ThemeData theme;

  const TimerScreen(this.theme, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _strMillis;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _strMillis = "00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cronómetro', 
              style: TextStyle(
                color: widget.theme.colorScheme.secondary,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _strCount,
                    style: TextStyle(
                      color: widget.theme.colorScheme.primary,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      height: 1.0
                    ),
                  ),
                  Text(
                    _strMillis,
                    style: TextStyle(
                      color: widget.theme.colorScheme.primary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      height: 1.0
                    ),
                  )
                ],
              
              )
            ),
            _buildWidgetButton()
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButton() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (_status == "Start") {
              _startTimer();
            } else if (_status == "Stop") {
              _timer.cancel();
              setState(() {
                _status = "Continue";
              });
            } else if (_status == "Continue") {
              _startTimer();
            }
          },
          child: _buildIcon(_status, widget.theme.colorScheme.secondary),
        ),
        ElevatedButton(
          onPressed: () {
            // ignore: unnecessary_null_comparison
            if (_timer != null) {
              _timer.cancel();
              setState(() {
                _count = 0;
                _strCount = "00:00:00";
                _strMillis = "00";
                _status = "Start";
              });
            }
          },
          child: Icon(Icons.restart_alt, color: widget.theme.colorScheme.secondary),
        ),
      ],
    );
  }

  Icon _buildIcon(String status, Color color) {
    Icon icon;

    if (status == "Start") {
      icon = const Icon(Icons.play_arrow);
    } else if (status == "Stop") {
      icon = const Icon(Icons.pause);
    } else {
      icon = const Icon(Icons.play_arrow);
    }
    return Icon(icon.icon, color: color);
  }

  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _count += 1;

        int millis = _count % 100;
        int second = (_count ~/ 100) % 60;
        int minute = (_count ~/ 6000) % 60;
        int hour = _count ~/ 360000;
        
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";

        _strMillis = millis < 10 ? "0$millis" : "$millis";
      });
    });
  }
}