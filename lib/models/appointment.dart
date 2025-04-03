class Appointment {
  final String doctor;
  final String purpose;
  final DateTime date;
  final TimeOfDay time;

  Appointment({
    required this.doctor,
    required this.purpose,
    required this.date,
    required this.time,
  });
}