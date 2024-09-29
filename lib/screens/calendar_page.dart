import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
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
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  void _fetchInitialData() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final shiftProvider = Provider.of<ShiftProvider>(context, listen: false);
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);

    _currentUserId = authService.currentUser?.uid;

    shiftProvider.fetchShiftPeriods();
    teamProvider.fetchTeams();
    employeeProvider.fetchEmployees();
    shiftProvider.fetchShifts(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShiftProvider>(
      builder: (context, shiftProvider, child) {
        if (shiftProvider.isLoading) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor)));
        }
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildCalendarContent(context),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: AppTheme.accentColor),
            backgroundColor: AppTheme.primaryColor,
            onPressed: () => _addShift(context),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Shift Calendar', style: TextStyle(fontWeight: FontWeight.w300)),
      actions: [
        IconButton(
          icon: Icon(Icons.brightness_6, color: AppTheme.primaryColor),
          onPressed: () {
            final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
            themeProvider.toggleTheme();
          },
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftPeriodsPage())),
        ),
        IconButton(
          icon: Icon(Icons.people),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeManagementPage())),
        ),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async => await context.read<AuthService>().signOut(),
        ),
      ],
    );
  }

  Widget _buildCalendarContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTableCalendar(),
          SizedBox(height: 8),
          _buildShiftList(),
          SizedBox(height: 16),
          _buildWeeklyShiftChart(),
          SizedBox(height: 16),
          _buildEmployeeShiftDistribution(),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return Consumer<ShiftProvider>(
      builder: (context, shiftProvider, child) {
        return TableCalendar(
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
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() => _calendarFormat = format);
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            shiftProvider.fetchShifts(focusedDay);
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, _) => _buildCalendarDayContainer(day, shiftProvider),
            selectedBuilder: (context, day, _) => _buildCalendarDayContainer(day, shiftProvider, isSelected: true),
            todayBuilder: (context, day, _) => _buildCalendarDayContainer(day, shiftProvider, isToday: true),
          ),
        );
      },
    );
  }

  Widget _buildCalendarDayContainer(DateTime day, ShiftProvider shiftProvider, {bool isSelected = false, bool isToday = false}) {
    final shifts = shiftProvider.shifts[DateTime(day.year, day.month, day.day)] ?? [];
    Color backgroundColor = Colors.transparent;

    if (shifts.isNotEmpty) {
      final shift = shifts.first;
      final shiftPeriod = shiftProvider.shiftPeriods.firstWhere(
        (period) => period.id == shift.shiftPeriodId,
        orElse: () => ShiftPeriod(name: '', startTime: TimeOfDay.now(), endTime: TimeOfDay.now(), color: Colors.grey, teamId: ''),
      );
      backgroundColor = shiftPeriod.color.withOpacity(0.3);
    }

    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
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

  Widget _buildShiftList() {
    return Consumer2<ShiftProvider, EmployeeProvider>(
      builder: (context, shiftProvider, employeeProvider, child) {
        if (_selectedDay == null) return Container();

        final selectedShifts = shiftProvider.shifts[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] ?? [];
        if (selectedShifts.isEmpty) {
          return Center(child: Text('No shifts scheduled for this day'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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
        );
      },
    );
  }

  void _addShift(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final initialEmployeeId = employeeProvider.employees.any((e) => e.id == _currentUserId) ? _currentUserId : null;

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
        title: Text('Delete Shift'),
        content: Text('Are you sure you want to delete this shift?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Delete'),
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

        return Container(
          height: 200,
          padding: EdgeInsets.all(16),
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
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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

        return Container(
          height: 300,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Employee Shift Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
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
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 8),
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
        );
      },
    );
  }
}