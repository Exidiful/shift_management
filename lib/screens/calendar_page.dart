import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glass_kit/glass_kit.dart';
import '../providers/shift_provider.dart';
import '../providers/employee_provider.dart';
import '../providers/team_provider.dart';
import '../models/shift.dart';
import '../models/shift_period.dart';
import '../widgets/shift_dialog.dart';
import '../services/auth_service.dart';
import 'shift_periods_page.dart';
import 'employee_management_page.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoadingShifts = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  void _fetchInitialData() {
    Provider.of<AuthService>(context, listen: false);
    final shiftProvider = Provider.of<ShiftProvider>(context, listen: false);
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);


    shiftProvider.fetchShiftPeriods();
    teamProvider.fetchTeams();
    employeeProvider.fetchEmployees();
    shiftProvider.fetchShifts(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return _buildCalendarContent(context);
  }

  Widget _buildCalendarContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTableCalendar(),
          const SizedBox(height: 8),
          _buildShiftList(),
          const SizedBox(height: 16),
          _buildWeeklyShiftChart(),
          const SizedBox(height: 16),
          _buildEmployeeShiftDistribution(),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return Consumer<ShiftProvider>(
      builder: (context, shiftProvider, child) {
        return GlassContainer(
          height: 400,
          width: MediaQuery.of(context).size.width - 32, // Subtract padding
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.40), Colors.white.withOpacity(0.10)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderGradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.60), Colors.white.withOpacity(0.10), Colors.lightBlueAccent.withOpacity(0.05), Colors.lightBlueAccent.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.39, 0.40, 1.0],
          ),
          blur: 10,
          borderRadius: BorderRadius.circular(24.0),
          borderWidth: 1.5,
          elevation: 3,
          isFrostedGlass: true,
          shadowColor: Colors.black.withOpacity(0.20),
          alignment: Alignment.center,
          frostedOpacity: 0.12,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay ) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              // Only fetch shifts for the selected day
              shiftProvider.fetchShifts(selectedDay);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() => _calendarFormat = format);
                // Fetch shifts for the visible range when format changes
                _fetchShiftsForVisibleRange(shiftProvider);
              }
            },
            onPageChanged: (focusedDay) {
              setState(() => _focusedDay = focusedDay);
              // Fetch shifts for the visible range when page changes
              _fetchShiftsForVisibleRange(shiftProvider);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) => _buildCalendarDayContainer(day, shiftProvider),
              selectedBuilder: (context, day, focusedDay) => _buildCalendarDayContainer(day, shiftProvider, isSelected: true),
              todayBuilder: (context, day, focusedDay) => _buildCalendarDayContainer(day, shiftProvider, isToday: true),
            ),
          ),
        );
      },
    );
  }

  void _fetchShiftsForVisibleRange(ShiftProvider shiftProvider) {
    setState(() {
      _isLoadingShifts = true;
    });
    final visibleDays = daysInRange(
      _calendarFormat == CalendarFormat.month
          ? _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1))
          : _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1)),
      _calendarFormat == CalendarFormat.month
          ? _focusedDay.add(Duration(days: DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day - _focusedDay.day + (7 - _focusedDay.weekday)))
          : _focusedDay.add(Duration(days: 7 - _focusedDay.weekday)),
    );
    shiftProvider.fetchShiftsForRange(visibleDays.first, visibleDays.last).then((_) {
      // Delay the setState call to allow for a smooth animation
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _isLoadingShifts = false;
        });
      });
    });
  }

  Widget _buildCalendarDayContainer(DateTime day, ShiftProvider shiftProvider, {bool isSelected = false, bool isToday = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: _getBackgroundColor(day, shiftProvider),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : (isToday ? AppTheme.accentColor : Colors.transparent),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: isSelected || isToday ? AppTheme.primaryColor : null,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(DateTime day, ShiftProvider shiftProvider) {
    if (_isLoadingShifts) {
      return Colors.transparent;
    }
    
    final shifts = shiftProvider.shifts[DateTime(day.year, day.month, day.day)] ?? [];
    if (shifts.isNotEmpty) {
      final shift = shifts.first;
      final shiftPeriod = shiftProvider.shiftPeriods.firstWhere(
        (period) => period.id == shift.shiftPeriodId,
        orElse: () => ShiftPeriod(name: '', startTime: TimeOfDay.now(), endTime: TimeOfDay.now(), color: Colors.grey, teamId: ''),
      );
      return shiftPeriod.color.withOpacity(0.3);
    }
    
    return Colors.transparent;
  }

  Widget _buildShiftList() {
    return Consumer2<ShiftProvider, EmployeeProvider>(
      builder: (context, shiftProvider, employeeProvider, child) {
        if (_selectedDay == null) return Container();

        final selectedShifts = shiftProvider.shifts[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] ?? [];
        if (selectedShifts.isEmpty) {
          return const Center(child: Text('No shifts scheduled for this day'));
        }

        return AnimatedOpacity(
          opacity: _isLoadingShifts ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: GlassContainer(
            height: 200,
            width: MediaQuery.of(context).size.width - 32,
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.40), Colors.white.withOpacity(0.10)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderGradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.60), Colors.white.withOpacity(0.10), Colors.lightBlueAccent.withOpacity(0.05), Colors.lightBlueAccent.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.39, 0.40, 1.0],
            ),
            blur: 10,
            borderRadius: BorderRadius.circular(16.0),
            borderWidth: 1.5,
            elevation: 3,
            isFrostedGlass: true,
            shadowColor: Colors.black.withOpacity(0.20),
            alignment: Alignment.center,
            frostedOpacity: 0.12,
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: selectedShifts.length,
              itemBuilder: (context, index) {
                final shift = selectedShifts[index];
                final employee = employeeProvider.getEmployeeById(shift.employeeId);
                return ListTile(
                  title: Text(shift.title),
                  subtitle: Text('${shift.startTime.format(context)} - ${shift.endTime.format(context)}'),
                  trailing: Text(employee?.name ?? 'Unknown Employee'),
                  onTap: () => _editShift(context, shift),
                  onLongPress: () => _deleteShift(context, shift),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _addShift(BuildContext context) {
    Provider.of<EmployeeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => ShiftDialog(
        shiftPeriods: Provider.of<ShiftProvider>(context, listen: false).shiftPeriods,
        onSave: (title, startTime, endTime, employeeId, shiftPeriodId) async {
          final shift = Shift(
            date: _selectedDay!,
            title: title,
            startTime: startTime,
            endTime: endTime,
            employeeId: employeeId,
            shiftPeriodId: shiftPeriodId,
          );
          await Provider.of<ShiftProvider>(context, listen: false).addShift(shift);
        },
      ),
    );
  }

  void _editShift(BuildContext context, Shift shift) {
    showDialog(
      context: context,
      builder: (context) => ShiftDialog(
        shift: shift,
        shiftPeriods: Provider.of<ShiftProvider>(context, listen: false).shiftPeriods,
        onSave: (title, startTime, endTime, employeeId, shiftPeriodId) async {
          final updatedShift = Shift(
            id: shift.id,
            date: shift.date,
            title: title,
            startTime: startTime,
            endTime: endTime,
            employeeId: employeeId,
            shiftPeriodId: shiftPeriodId,
          );
          await Provider.of<ShiftProvider>(context, listen: false).updateShift(updatedShift);
        },
      ),
    );
  }

  void _deleteShift(BuildContext context, Shift shift) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shift'),
        content: const Text('Are you sure you want to delete this shift?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              await Provider.of<ShiftProvider>(context, listen: false).deleteShift(shift);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyShiftChart() {
    return Consumer<ShiftProvider>(
      builder: (context, shiftProvider, child) {
        final weekStart = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
        final weekShifts = List.generate(7, (index) {
          final day = weekStart.add(Duration(days: index));
          return shiftProvider.shifts[day]?.length ?? 0;
        });

        return AnimatedOpacity(
          opacity: _isLoadingShifts ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: _isLoadingShifts
              ? const Center(child: CircularProgressIndicator())
              : GlassContainer(
                  height: 250,
                  width: MediaQuery.of(context).size.width - 32,
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.40), Colors.white.withOpacity(0.10)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderGradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.60), Colors.white.withOpacity(0.10), Colors.lightBlueAccent.withOpacity(0.05), Colors.lightBlueAccent.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.39, 0.40, 1.0],
                  ),
                  blur: 10,
                  borderRadius: BorderRadius.circular(16.0),
                  borderWidth: 1.5,
                  elevation: 3,
                  isFrostedGlass: true,
                  shadowColor: Colors.black.withOpacity(0.20),
                  alignment: Alignment.center,
                  frostedOpacity: 0.12,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(16.0),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: weekShifts.reduce((a, b) => a > b ? a : b).toDouble(),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                              return Text(days[value.toInt()]);
                            },
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(7, (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [BarChartRodData(toY: weekShifts[index].toDouble())],
                        );
                      }),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildEmployeeShiftDistribution() {
    return Consumer2<ShiftProvider, EmployeeProvider>(
      builder: (context, shiftProvider, employeeProvider, child) {
        final employeeShiftCounts = <String, int>{};
        shiftProvider.shifts.values.expand((shifts) => shifts).forEach((shift) {
          employeeShiftCounts[shift.employeeId] = (employeeShiftCounts[shift.employeeId] ?? 0) + 1;
        });

        final totalShifts = employeeShiftCounts.values.fold(0, (sum, count) => sum + count);

        return AnimatedOpacity(
          opacity: _isLoadingShifts ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: _isLoadingShifts
              ? const Center(child: CircularProgressIndicator())
              : GlassContainer(
                  height: 350,
                  width: MediaQuery.of(context).size.width - 32,
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.40), Colors.white.withOpacity(0.10)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderGradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.60), Colors.white.withOpacity(0.10), Colors.lightBlueAccent.withOpacity(0.05), Colors.lightBlueAccent.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.39, 0.40, 1.0],
                  ),
                  blur: 10,
                  borderRadius: BorderRadius.circular(16.0),
                  borderWidth: 1.5,
                  elevation: 3,
                  isFrostedGlass: true,
                  shadowColor: Colors.black.withOpacity(0.20),
                  alignment: Alignment.center,
                  frostedOpacity: 0.12,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Employee Shift Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sections: employeeShiftCounts.entries.map((entry) {
                              final employee = employeeProvider.getEmployeeById(entry.key);
                              return PieChartSectionData(
                                color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
                                value: entry.value.toDouble(),
                                title: '${(entry.value / totalShifts * 100).toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: employeeShiftCounts.entries.map((entry) {
                          final employee = employeeProvider.getEmployeeById(entry.key);
                          return Chip(
                            label: Text(employee?.name ?? 'Unknown'),
                            backgroundColor: Colors.primaries[entry.key.hashCode % Colors.primaries.length].withOpacity(0.3),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

// Helper function to generate a list of days between two dates
List<DateTime> daysInRange(DateTime start, DateTime end) {
  final days = <DateTime>[];
  for (int i = 0; i <= end.difference(start).inDays; i++) {
    days.add(start.add(Duration(days: i)));
  }
  return days;
}