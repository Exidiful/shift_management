import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/shift_period.dart';
import '../models/team.dart';
import '../utils/app_theme.dart';

class ShiftPeriodDialog extends StatefulWidget {
  final ShiftPeriod? shiftPeriod;
  final List<Team> teams;
  final Function(String, TimeOfDay, TimeOfDay, Color, String) onSave;

  ShiftPeriodDialog({
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
    _startTime = widget.shiftPeriod?.startTime ?? TimeOfDay(hour: 9, minute: 0);
    _endTime = widget.shiftPeriod?.endTime ?? TimeOfDay(hour: 17, minute: 0);
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
              decoration: InputDecoration(labelText: 'Period Name'),
            ),
            SizedBox(height: 16),
            _buildTimePicker('Start Time', _startTime, (time) => setState(() => _startTime = time)),
            _buildTimePicker('End Time', _endTime, (time) => setState(() => _endTime = time)),
            SizedBox(height: 16),
            _buildColorPicker(),
            SizedBox(height: 16),
            _buildTeamDropdown(),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Save'),
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
                SnackBar(content: Text('Please select a team')),
              );
            }
          },
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
        Text('Color'),
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
      hint: Text('Select Team'),
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
      decoration: InputDecoration(labelText: 'Team'),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}