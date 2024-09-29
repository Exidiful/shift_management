import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shift_provider.dart';
import '../providers/team_provider.dart';
import '../models/shift_period.dart';
import '../widgets/shift_period_dialog.dart';

class ShiftPeriodsPage extends StatelessWidget {
  const ShiftPeriodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shift Periods')),
      body: Consumer2<ShiftProvider, TeamProvider>(
        builder: (context, shiftProvider, teamProvider, child) {
          if (shiftProvider.isLoading || teamProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: shiftProvider.shiftPeriods.length,
            itemBuilder: (context, index) {
              final period = shiftProvider.shiftPeriods[index];
              final team = teamProvider.getTeamById(period.teamId);
              return ListTile(
                title: Text(period.name),
                subtitle: Text('${period.startTime.format(context)} - ${period.endTime.format(context)}\nTeam: ${team?.name ?? 'Unknown'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: period.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editShiftPeriod(context, shiftProvider, teamProvider, period),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteShiftPeriod(context, shiftProvider, period),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addShiftPeriod(context),
      ),
    );
  }

  void _addShiftPeriod(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ShiftPeriodDialog(
        teams: Provider.of<TeamProvider>(context, listen: false).teams,
        onSave: (String name, TimeOfDay startTime, TimeOfDay endTime, Color color, String teamId) {
          final newPeriod = ShiftPeriod(
            name: name,
            startTime: startTime,
            endTime: endTime,
            color: color,
            teamId: teamId,
          );
          Provider.of<ShiftProvider>(context, listen: false).addShiftPeriod(newPeriod);
        },
      ),
    );
  }

  void _editShiftPeriod(BuildContext context, ShiftProvider provider, TeamProvider teamProvider, ShiftPeriod period) {
    showDialog(
      context: context,
      builder: (context) => ShiftPeriodDialog(
        shiftPeriod: period,
        teams: teamProvider.teams,
        onSave: (String name, TimeOfDay startTime, TimeOfDay endTime, Color color, String teamId) {
          final updatedPeriod = ShiftPeriod(
            id: period.id,
            name: name,
            startTime: startTime,
            endTime: endTime,
            color: color,
            teamId: teamId,
          );
          provider.updateShiftPeriod(updatedPeriod);
        },
      ),
    );
  }

  void _deleteShiftPeriod(BuildContext context, ShiftProvider provider, ShiftPeriod period) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shift Period'),
        content: const Text('Are you sure you want to delete this shift period?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              provider.deleteShiftPeriod(period.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}