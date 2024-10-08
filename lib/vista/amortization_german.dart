// archivo: lib/vista/amortization_german.dart

import 'package:flutter/material.dart';
import 'dart:math';

class AmortizationGerman extends StatefulWidget {
  @override
  _AmortizationGermanState createState() => _AmortizationGermanState();
}

class _AmortizationGermanState extends State<AmortizationGerman> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<AmortizationSchedule> _schedule = [];

  void _calculateAmortization() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double annualRate = (double.tryParse(_rateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_timeController.text) ?? 0;

    if (principal <= 0 || annualRate < 0 || periods <= 0) {
      _showAlertDialog('Por favor, ingrese valores válidos.');
      return;
    }

    double capitalPerPeriod = principal / periods;
    double remainingPrincipal = principal;
    List<AmortizationSchedule> tempSchedule = [];

    for (int i = 1; i <= periods; i++) {
      double interest = remainingPrincipal * (annualRate / 12); // Suponiendo pagos mensuales
      double payment = capitalPerPeriod + interest;
      remainingPrincipal -= capitalPerPeriod;

      tempSchedule.add(AmortizationSchedule(
        period: i,
        payment: payment,
        capital: capitalPerPeriod,
        interest: interest,
        remainingPrincipal: remainingPrincipal < 0 ? 0 : remainingPrincipal,
      ));
    }

    setState(() {
      _schedule = tempSchedule;
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
                DataCell(Text('\$${entry.remainingPrincipal.toStringAsFixed(2)}')),
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
          title: Text('Amortización Alemán'),
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
