import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khadim_e_insaniyat/modules/widgets/fields/app_input_field/app_input_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppDatePicker extends StatefulWidget {
  final String label;
  final ValueChanged<DateTime>? onChange;

  const AppDatePicker({
    super.key,
    required this.label,
    this.onChange,
  });

  @override
  State<AppDatePicker> createState() => _AppDatePicker();
}

class _AppDatePicker extends State<AppDatePicker> {
  late TextEditingController dateController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  late FocusNode dateFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  bool showDate = false;  // Toggle for showing the overlay

  void _toggleDatePickerOverlay() {
    if (showDate) {
      // Remove the overlay if already visible
      _overlayEntry?.remove();
      _overlayEntry = null;
      showDate = false;
    } else {
      // Create and show the overlay
      _overlayEntry = _createDatePickerOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      showDate = true;
    }
  }

  OverlayEntry _createDatePickerOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + renderBox.size.height,
        width: renderBox.size.width,
        child: Material(
          elevation: 4.0,
          child: SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.single,
            initialSelectedDate: DateTime.now(),
          ),
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      final selectedDate = args.value as DateTime;
      dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      widget.onChange?.call(selectedDate);
    }
    _toggleDatePickerOverlay();  // Close the overlay after a date is selected
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    dateController.dispose();
    dateFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppInputField.text(
      controller: dateController,
      focusNode: dateFocusNode,
      label: widget.label,
      onTap: _toggleDatePickerOverlay,
    );
  }
}
