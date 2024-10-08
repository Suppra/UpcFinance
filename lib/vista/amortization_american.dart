// archivo: lib/vista/amortization_american.dart

import 'package:flutter/material.dart';
import 'dart:math';

class AmortizationAmerican extends StatefulWidget {
  @override
  _AmortizationAmericanState createState() => _AmortizationAmericanState();
}

class _AmortizationAmericanState extends State<AmortizationAmerican> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<AmortizationSchedule> _schedule = [];
  double _finalPayment = 0.0;

  void _calculateAmortization() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double annualRate = (double.tryParse(_rateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_timeController.text) ?? 0;

    if (principal <= 0 || annualRate < 0 || periods <= 0) {
      _showAlertDialog('Por favor, ingrese valores válidos.');
      return;
    }

    double monthlyRate = annualRate / 12;
    double interestPayment = principal * monthlyRate;

    List<AmortizationSchedule> tempSchedule = [];

    for (int i = 1; i < periods; i++) {
      tempSchedule.add(AmortizationSchedule(
        period: i,
        payment: interestPayment,
        capital: 0.0,
        interest: interestPayment,
        remainingPrincipal: principal,
      ));
    }

    // Pago final incluye el capital
    tempSchedule.add(AmortizationSchedule(
      period: periods,
      payment: interestPayment + principal,
      capital: principal,
      interest: interestPayment,
      remainingPrincipal: 0.0,
    ));

    setState(() {
      _schedule = tempSchedule;
      _finalPayment = interestPayment + principal;
    });
  }

  Future<void> _showAlertDialog(String message) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alerta'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTable() {
    if (_schedule.isEmpty) {
      return Text('No hay cálculos para mostrar.');
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Periodo')),
          DataColumn(label: Text('Pago')),
          DataColumn(label: Text('Capital')),
          DataColumn(label: Text('Interés')),
          DataColumn(label: Text('Principal Restante')),
        ],
        rows: _schedule
            .map(
              (entry) => DataRow(cells: [
                DataCell(Text(entry.period.toString())),
                DataCell(Text('\$${entry.payment.toStringAsFixed(2)}')),
                DataCell(Text('\$${entry.capital.toStringAsFixed(2)}')),
                DataCell(Text('\$${entry.interest.toStringAsFixed(2)}')),
                DataCell(
                    Text('\$${entry.remainingPrincipal.toStringAsFixed(2)}')),
              ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Amortización Americano'),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _principalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Capital Inicial (P)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _rateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tasa de Interés Anual (%) (i)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _timeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tiempo (meses) (n)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateAmortization,
                  child: Text('Calcular Amortización'),
                ),
                SizedBox(height: 24),
                _buildScheduleTable(),
              ],
            ),
          ),
        ));
  }
}

class AmortizationSchedule {
  final int period;
  final double payment;
  final double capital;
  final double interest;
  final double remainingPrincipal;

  AmortizationSchedule({
    required this.period,
    required this.payment,
    required this.capital,
    required this.interest,
    required this.remainingPrincipal,
  });
}
