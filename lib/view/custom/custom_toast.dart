import 'package:flutter/material.dart';

enum ToastPosition {
  top,
  center,
  bottom,
}

class Toast {
  static OverlayEntry? _overlayEntry;
  static bool _showing = false;
  static late DateTime _startedTime;
  static  late String _msg;
  static late  int _showTime;
  static  late Color _bgColor;
  static  late Color _textColor;
  static  late double _textSize;
  static late ToastPosition _toastPosition;
  static late double _pdHorizontal;
  static late double _pdVertical;
  static void toast(
      BuildContext context, {
        String? msg,
        int showTime = 1000,
        Color bgColor = Colors.black,
        Color textColor = Colors.white,
        double textSize = 14.0,
        ToastPosition position = ToastPosition.center,
        double pdHorizontal = 20.0,
        double pdVertical = 10.0,
      }) async {
    assert(msg != null);
    _msg = msg!;
    _startedTime = DateTime.now();
    _showTime = showTime;
    _bgColor = bgColor;
    _textColor = textColor;
    _textSize = textSize;
    _toastPosition = position;
    _pdHorizontal = pdHorizontal;
    _pdVertical = pdVertical;
    OverlayState overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
            top: buildToastPosition(context),
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: AnimatedOpacity(
                    opacity: _showing ? 1.0 : 0.0,
                    duration: _showing
                        ? const Duration(milliseconds: 100)
                        : const Duration(milliseconds: 400),
                    child: _buildToastWidget(),
                  ),
                )),
          ));
      overlayState.insert(_overlayEntry!);
    } else {
      _overlayEntry?.markNeedsBuild();
    }
    await Future.delayed(Duration(milliseconds: _showTime));
    if (DateTime.now().difference(_startedTime).inMilliseconds >= _showTime) {
      _showing = false;
      _overlayEntry?.markNeedsBuild();
      await Future.delayed(const Duration(milliseconds: 400));
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static _buildToastWidget() {
    return Center(
      child: Card(
        color: _bgColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _pdHorizontal, vertical: _pdVertical),
          child: Text(
            _msg,
            style: TextStyle(
              fontSize: _textSize,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }

  static buildToastPosition(context) {
    double backResult;
    if (_toastPosition == ToastPosition.top) {
      backResult = 1 / 4;
    } else if (_toastPosition == ToastPosition.center) {
      backResult = 2 / 5;
    } else {
      backResult = 3 / 4;
    }
    return MediaQuery.of(context).size.height * backResult;
  }
}