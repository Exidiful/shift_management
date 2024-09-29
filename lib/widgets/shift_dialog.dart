import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shift_period.dart';
import '../models/shift.dart';
import '../providers/employee_provider.dart';

class ShiftDialog extends StatefulWidget {
  final Shift? shift;
  final List<ShiftPeriod> shiftPeriods;
  final Function(String, TimeOfDay, TimeOfDay, String, String) onSave;

  const ShiftDialog({super.key, 
    this.shift,
    required this.shiftPeriods,
    required this.onSave,
  });

  @override
  _ShiftDialogState createState() => _ShiftDialogState();
}

class _ShiftDialogState extends State<ShiftDialog> {
  late TextEditingController _titleController;
  ShiftPeriod? _selectedPeriod;
  String? _selectedEmployeeId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.shift?.title ?? '');
    _selectedEmployeeId = widget.shift?.employeeId;
    if (widget.shift != null) {
      _selectedPeriod = widget.shiftPeriods.firstWhere(
        (period) => period.id == widget.shift!.shiftPeriodId,
        orElse: () => widget.shiftPeriods.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.shift == null ? 'Add Shift' : 'Edit Shift'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ShiftPeriod>(
              value: _selectedPeriod,
              hint: const Text('Select Shift Period'),
              isExpanded: true,
              items: widget.shiftPeriods.map((ShiftPeriod period) {
                return DropdownMenuItem<ShiftPeriod>(
                  value: period,
                  child: Text('${period.name} (${period.startTime.format(context)} - ${period.endTime.format(context)})'),
                );
              }).toList(),
              onChanged: (ShiftPeriod? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPeriod = newValue;
                    _titleController.text = newValue.name;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Shift Title'),
            ),
            const SizedBox(height: 16),
            Consumer<EmployeeProvider>(
              builder: (context, employeeProvider, child) {
                return DropdownButtonFormField<String>(
                  value: _selectedEmployeeId,
                  hint: const Text('Select Employee'),
                  isExpanded: true,
                  items: employeeProvider.employees.map((employee) {
                    return DropdownMenuItem<String>(
                      value: employee.id,
                      child: Text(employee.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedEmployeeId = newValue;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            if (_selectedPeriod != null && _selectedEmployeeId != null) {
              widget.onSave(
                _titleController.text,
                _selectedPeriod!.startTime,
                _selectedPeriod!.endTime,
                _selectedEmployeeId!,
                _selectedPeriod!.id!,
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a shift period and an employee')),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}