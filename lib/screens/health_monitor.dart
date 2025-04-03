import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:health_monitor/models/health_metric.dart';

class HealthMonitorScreen extends StatefulWidget {
  const HealthMonitorScreen({super.key});

  @override
  State<HealthMonitorScreen> createState() => _HealthMonitorScreenState();
}

class _HealthMonitorScreenState extends State<HealthMonitorScreen> {
  final List<HealthMetric> _bloodPressureData = [
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 6)), value: 120, metricType: 'Systolic'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 5)), value: 118, metricType: 'Systolic'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 4)), value: 122, metricType: 'Systolic'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 3)), value: 125, metricType: 'Systolic'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 2)), value: 119, metricType: 'Systolic'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 1)), value: 121, metricType: 'Systolic'),
    HealthMetric(date: DateTime.now(), value: 117, metricType: 'Systolic'),
  ];

  final List<HealthMetric> _glucoseData = [
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 6)), value: 95, metricType: 'Glucose'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 5)), value: 102, metricType: 'Glucose'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 4)), value: 98, metricType: 'Glucose'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 3)), value: 110, metricType: 'Glucose'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 2)), value: 105, metricType: 'Glucose'),
    HealthMetric(date: DateTime.now().subtract(const Duration(days: 1)), value: 99, metricType: 'Glucose'),
    HealthMetric(date: DateTime.now(), value: 97, metricType: 'Glucose'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Blood Pressure',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: charts.TimeSeriesChart(
                      [
                        charts.Series<HealthMetric, DateTime>(
                          id: 'Blood Pressure',
                          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (HealthMetric metric, _) => metric.date,
                          measureFn: (HealthMetric metric, _) => metric.value,
                          data: _bloodPressureData,
                        )
                      ],
                      animate: true,
                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Blood Glucose',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: charts.TimeSeriesChart(
                      [
                        charts.Series<HealthMetric, DateTime>(
                          id: 'Glucose',
                          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                          domainFn: (HealthMetric metric, _) => metric.date,
                          measureFn: (HealthMetric metric, _) => metric.value,
                          data: _glucoseData,
                        )
                      ],
                      animate: true,
                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement manual data entry
            },
            child: const Text('Add Manual Reading'),
          ),
        ],
      ),
    );
  }
}