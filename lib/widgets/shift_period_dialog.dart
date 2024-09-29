import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/shift_period.dart';
import '../models/team.dart';
import '../utils/app_theme.dart';

class ShiftPeriodDialog extends StatefulWidget {
  final ShiftPeriod? shiftPeriod;
  final List<Team> teams;
  final Function(String, TimeOfDay, TimeOfDay, Color, String) onSave;

  const ShiftPeriodDialog({super.key, 
    this.shiftPeriod,
    required this.teams,
    required this.onSave,
  });

  @override
  _ShiftPeriodDialogState createState() => _ShiftPeriodDialogState();
}

class _ShiftPeriodDialogState extends State<ShiftPeriodDialog> {
  late TextEditingController _nameController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late Color _color;
  String? _selectedTeamId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shiftPeriod?.name ?? '');
    _startTime = widget.shiftPeriod?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    _endTime = widget.shiftPeriod?.endTime ?? const TimeOfDay(hour: 17, minute: 0);
    _color = widget.shiftPeriod?.color ?? Colors.blue;
    _selectedTeamId = widget.shiftPeriod?.teamId;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.shiftPeriod == null ? 'Add Shift Period' : 'Edit Shift Period'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Period Name'),
            ),
            const SizedBox(height: 16),
            _buildTimePicker('Start Time', _startTime, (time) => setState(() => _startTime = time)),
            _buildTimePicker('End Time', _endTime, (time) => setState(() => _endTime = time)),
            const SizedBox(height: 16),
            _buildColorPicker(),
            const SizedBox(height: 16),
            _buildTeamDropdown(),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: AppTheme.accentColor,
          ),
          onPressed: () {
            if (_selectedTeamId != null) {
              widget.onSave(
                _nameController.text,
                _startTime,
                _endTime,
                _color,
                _selectedTeamId!,
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a team')),
              );
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, Function(TimeOfDay) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        TextButton(
          child: Text(time.format(context)),
          onPressed: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null) {
              onChanged(picked);
            }
          },
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Color'),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Pick a color'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: _color,
                      onColorChanged: (Color color) {
                        setState(() => _color = color);
                      },
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTeamId,
      hint: const Text('Select Team'),
      items: widget.teams.map((Team team) {
        return DropdownMenuItem<String>(
          value: team.id,
          child: Text(team.name),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTeamId = newValue;
        });
      },
      decoration: const InputDecoration(labelText: 'Team'),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}