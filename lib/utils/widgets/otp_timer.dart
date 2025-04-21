import 'dart:async';

import 'package:flutter/material.dart';

class OtpTimerWidget extends StatefulWidget {
  final VoidCallback onTimerComplete;
  final OtpTimerController? controller;

  const OtpTimerWidget({
    super.key,
    required this.onTimerComplete,
    this.controller,
  });

  @override
  State<OtpTimerWidget> createState() => _OtpTimerWidgetState();
}

class _OtpTimerWidgetState extends State<OtpTimerWidget> {
  static const int _startTime = 300;
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _startTime;
    _startTimer();

    // Bind controller
    widget.controller?._bind(_resetTimer);
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller?._unbind();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        widget.onTimerComplete();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _secondsRemaining = _startTime;
    });
    _startTimer();
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Expires in ${_formatTime(_secondsRemaining)}",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: _secondsRemaining < 10 ? Colors.redAccent : Colors.grey[700],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class OtpTimerController {
  void Function()? _resetCallback;

  void reset() {
    if (_resetCallback != null) {
      _resetCallback!();
    }
  }

  void _bind(void Function() resetFn) {
    _resetCallback = resetFn;
  }

  void _unbind() {
    _resetCallback = null;
  }
}
