import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_monitor/models/appointment.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<Appointment> _appointments = [];
  final _formKey = GlobalKey<FormState>();
  final _doctorController = TextEditingController();
  final _purposeController = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                final appointment = _appointments[index];
                return ListTile(
                  title: Text(appointment.doctor),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(appointment.date)} at ${appointment.time.format(context)}\n'
                    'Purpose: ${appointment.purpose}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _appointments.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _doctorController,
                    decoration: const InputDecoration(
                      labelText: 'Doctor',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter doctor name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _purposeController,
                    decoration: const InputDecoration(
                      labelText: 'Purpose',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter purpose';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text('Date'),
                    subtitle: Text(DateFormat.yMMMd().format(_date)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text('Time'),
                    subtitle: Text(_time.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final appointment = Appointment(
                          doctor: _doctorController.text,
                          purpose: _purposeController.text,
                          date: _date,
                          time: _time,
                        );
                        setState(() {
                          _appointments.add(appointment);
                        });
                        _doctorController.clear();
                        _purposeController.clear();
                      }
                    },
                    child: const Text('Schedule Appointment'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}