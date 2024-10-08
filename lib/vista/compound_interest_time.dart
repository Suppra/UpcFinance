// archivo: lib/vista/compound_interest_time.dart

import 'package:flutter/material.dart';
import 'dart:math';

class CompoundInterestTime extends StatefulWidget {
  @override
  _CompoundInterestTimeState createState() => _CompoundInterestTimeState();
}

class _CompoundInterestTimeState extends State<CompoundInterestTime> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _futureAmountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _compoundingController = TextEditingController();
  double _time = 0.0;

  void _calculateTime() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double futureAmount = double.tryParse(_futureAmountController.text) ?? 0.0;
    double rate = (double.tryParse(_rateController.text) ?? 0.0) / 100;
    double n = double.tryParse(_compoundingController.text) ?? 1.0;

    if (principal > 0 && rate > 0 && futureAmount > 0 && n > 0 && futureAmount > principal) {
      double t = (log(futureAmount / principal)) / (n * log(1 + rate / n));
      setState(() {
        _time = t;
      });
    } else {
      setState(() {
        _time = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Interés Compuesto - Tiempo'),
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
                  controller: _futureAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monto Futuro (A)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _rateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tasa de Interés (%) (R)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _compoundingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Número de Capitalizaciones por Año (n)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateTime,
                  child: Text('Calcular Tiempo'),
                ),
                SizedBox(height: 24),
                Text(
                  'Tiempo (T): ${_time.toStringAsFixed(2)} años',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
