// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'month_name_handler.dart';

typedef TextMapper = String Function(String numberText);

class NumberPicker extends StatelessWidget {
  static const double kDefaultItemExtent = 50.0;

  static const double kDefaultListViewCrossAxisSize = 100.0;

  NumberPicker.integer({
    super.key,
    required int initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    this.enabled = true,
    this.textMapper,
    this.itemExtent = kDefaultItemExtent,
    this.listViewWidth = kDefaultListViewCrossAxisSize,
    this.step = 1,
    this.scrollDirection = Axis.vertical,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
    this.haptics = false,
    this.selectedRowStyle,
    this.unselectedRowStyle,
    this.isShowMonthName = false,
    this.isJalali = false,
  })  : assert(maxValue >= minValue),
        assert(step > 0),
        selectedIntValue = (initialValue < minValue)
            ? minValue
            : ((initialValue > maxValue) ? maxValue : initialValue),
        selectedDecimalValue = -1,
        decimalPlaces = 0,
        intScrollController = ScrollController(
          initialScrollOffset: (initialValue - minValue) ~/ step * itemExtent,
        ),
        decimalScrollController = null,
        listViewHeight = 3 * itemExtent,
        integerItemCount = (maxValue - minValue) ~/ step + 1 {
    onChanged(selectedIntValue);
  }

  final ValueChanged<num> onChanged;

  final int minValue;

  final int maxValue;

  final bool enabled;

  final TextMapper? textMapper;

  final int decimalPlaces;

  final double itemExtent;

  final double listViewHeight;

  final double? listViewWidth;

  final ScrollController intScrollController;

  final ScrollController? decimalScrollController;

  final int selectedIntValue;

  final int selectedDecimalValue;

  final bool highlightSelectedValue;

  final Decoration? decoration;

  final int step;

  final Axis scrollDirection;

  final bool zeroPad;

  final int integerItemCount;

  final bool haptics;

  final TextStyle? selectedRowStyle;

  final TextStyle? unselectedRowStyle;

  final bool? isShowMonthName;

  final bool? isJalali;

  void animateInt(int valueToSelect) {
    int diff = valueToSelect - minValue;
    int index = diff ~/ step;
    animateIntToIndex(index);
  }

  void animateIntToIndex(int index) {
    _animate(intScrollController, index * itemExtent);
  }

  void animateDecimal(int decimalValue) {
    _animate(decimalScrollController!, decimalValue * itemExtent);
  }

  void animateDecimalAndInteger(double valueToSelect) {
    animateInt(valueToSelect.floor());
    animateDecimal(((valueToSelect - valueToSelect.floorToDouble()) *
            math.pow(10, decimalPlaces))
        .round());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return _integerListView(themeData);
  }

  Widget _integerListView(ThemeData themeData) {
    TextStyle defaultStyle;
    TextStyle selectedStyle;

    defaultStyle = unselectedRowStyle ?? themeData.textTheme.bodyMedium!;
    selectedStyle = selectedRowStyle ?? themeData.textTheme.titleSmall!;

    var listItemCount = integerItemCount + 2;

    return Listener(
      onPointerUp: (ev) {
        if (intScrollController.position.activity is HoldScrollActivity) {
          animateInt(selectedIntValue);
        }
      },
      child: NotificationListener(
        onNotification: _onIntegerNotification,
        child: SizedBox(
          height: listViewHeight,
          width: listViewWidth,
          child: Stack(
            children: <Widget>[
              ListView.builder(
                scrollDirection: scrollDirection,
                controller: intScrollController,
                itemExtent: itemExtent,
                physics: enabled
                    ? const ClampingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: listItemCount,
                cacheExtent: _calculateCacheExtent(listItemCount),
                itemBuilder: (BuildContext context, int index) {
                  final int value = _intValueFromIndex(index);

                  final TextStyle itemStyle =
                      value == selectedIntValue && highlightSelectedValue
                          ? selectedStyle
                          : defaultStyle;

                  bool isExtra = index == 0 || index == listItemCount - 1;

                  return isExtra
                      ? Container()
                      : Center(
                          child: Text(
                            getDisplayedValue(value),
                            style: itemStyle,
                          ),
                        );
                },
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDisplayedValue(int value) {
    if (isShowMonthName!) {
      return value.getMonthName(isJalali!);
    } else {
      final text = zeroPad
          ? value.toString().padLeft(maxValue.toString().length, '0')
          : value.toString();
      return textMapper != null ? textMapper!(text) : text;
    }
  }

  int _intValueFromIndex(int index) {
    index--;
    index %= integerItemCount;
    return minValue + index * step;
  }

  bool _onIntegerNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate
      int intIndexOfMiddleElement =
          (notification.metrics.pixels / itemExtent).round();
      intIndexOfMiddleElement =
          intIndexOfMiddleElement.clamp(0, integerItemCount - 1);
      int intValueInTheMiddle = _intValueFromIndex(intIndexOfMiddleElement + 1);
      intValueInTheMiddle = _normalizeIntegerMiddleValue(intValueInTheMiddle);

      if (_userStoppedScrolling(notification, intScrollController)) {
        //center selected value
        animateIntToIndex(intIndexOfMiddleElement);
      }

      //update selection
      if (intValueInTheMiddle != selectedIntValue) {
        num newValue;
        if (decimalPlaces == 0) {
          newValue = (intValueInTheMiddle);
        } else {
          if (intValueInTheMiddle == maxValue) {
            newValue = (intValueInTheMiddle.toDouble());
            animateDecimal(0);
          } else {
            //return integer+decimal
            double decimalPart = _toDecimal(selectedDecimalValue);
            newValue = ((intValueInTheMiddle + decimalPart).toDouble());
          }
        }
        if (haptics) {
          HapticFeedback.selectionClick();
        }
        onChanged(newValue);
      }
    }
    return true;
  }

  double _calculateCacheExtent(int itemCount) {
    double cacheExtent = 250.0;
    if ((itemCount - 2) * kDefaultItemExtent <= cacheExtent) {
      cacheExtent = ((itemCount - 3) * kDefaultItemExtent);
    }
    return cacheExtent;
  }

  int _normalizeMiddleValue(int valueInTheMiddle, int min, int max) {
    return math.max(math.min(valueInTheMiddle, max), min);
  }

  int _normalizeIntegerMiddleValue(int integerValueInTheMiddle) {
    int max = (maxValue ~/ step) * step;
    return _normalizeMiddleValue(integerValueInTheMiddle, minValue, max);
  }

  bool _userStoppedScrolling(
    Notification notification,
    ScrollController scrollController,
  ) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  double _toDecimal(int decimalValueAsInteger) {
    return double.parse((decimalValueAsInteger * math.pow(10, -decimalPlaces))
        .toStringAsFixed(decimalPlaces));
  }

  _animate(ScrollController scrollController, double value) {
    scrollController.animateTo(
      value,
      duration: const Duration(seconds: 1),
      curve: const ElasticOutCurve(),
    );
  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  final Axis axis;
  final double itemExtent;
  final Decoration? decoration;

  const _NumberPickerSelectedItemDecoration(
      {required this.axis, required this.itemExtent, required this.decoration});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: Container(
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }

  bool get isVertical => axis == Axis.vertical;
}

class NumberPickerDialog extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialIntegerValue;
  final double initialDoubleValue;
  final int decimalPlaces;
  final Widget? title;
  final EdgeInsets? titlePadding;
  final Widget confirmWidget;
  final Widget cancelWidget;
  final int step;
  final bool infiniteLoop;
  final bool zeroPad;
  final bool highlightSelectedValue;
  final Decoration? decoration;
  final TextMapper? textMapper;
  final bool haptics;

  final bool isShowMonthName;
  final bool isJalali;

  const NumberPickerDialog.integer({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialIntegerValue,
    this.title,
    this.titlePadding,
    this.step = 1,
    this.infiniteLoop = false,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
    this.textMapper,
    this.haptics = false,
    Widget? confirmWidget,
    Widget? cancelWidget,
    this.isShowMonthName = false,
    this.isJalali = false,
  })  : confirmWidget = confirmWidget ?? const Text("OK"),
        cancelWidget = cancelWidget ?? const Text("CANCEL"),
        decimalPlaces = 0,
        initialDoubleValue = -1.0;

  const NumberPickerDialog.decimal({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialDoubleValue,
    this.decimalPlaces = 1,
    this.title,
    this.titlePadding,
    this.highlightSelectedValue = true,
    this.decoration,
    this.textMapper,
    this.haptics = false,
    Widget? confirmWidget,
    Widget? cancelWidget,
    this.isShowMonthName = false,
    this.isJalali = false,
  })  : confirmWidget = confirmWidget ?? const Text("OK"),
        cancelWidget = cancelWidget ?? const Text("CANCEL"),
        initialIntegerValue = -1,
        step = 1,
        infiniteLoop = false,
        zeroPad = false;

  @override
  // ignore: no_logic_in_create_state
  State<NumberPickerDialog> createState() => _NumberPickerDialogControllerState(
      initialIntegerValue, initialDoubleValue);
}

class _NumberPickerDialogControllerState extends State<NumberPickerDialog> {
  int selectedIntValue;
  double selectedDoubleValue;

  _NumberPickerDialogControllerState(
      this.selectedIntValue, this.selectedDoubleValue);

  void _handleValueChanged(num value) {
    if (value is int) {
      setState(() => selectedIntValue = value);
    } else {
      setState(() => selectedDoubleValue = value as double);
    }
  }

  NumberPicker _buildNumberPicker() {
    return NumberPicker.integer(
      initialValue: selectedIntValue,
      minValue: widget.minValue,
      maxValue: widget.maxValue,
      step: widget.step,
      zeroPad: widget.zeroPad,
      highlightSelectedValue: widget.highlightSelectedValue,
      decoration: widget.decoration,
      onChanged: _handleValueChanged,
      textMapper: widget.textMapper,
      haptics: widget.haptics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      titlePadding: widget.titlePadding,
      content: _buildNumberPicker(),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget,
        ),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(widget.decimalPlaces > 0
                ? selectedDoubleValue
                : selectedIntValue),
            child: widget.confirmWidget),
      ],
    );
  }
}
