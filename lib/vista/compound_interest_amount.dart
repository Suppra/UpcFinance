// archivo: lib/vista/compound_interest_amount.dart

import 'package:flutter/material.dart';
import 'dart:math';

class CompoundInterestAmount extends StatefulWidget {
  @override
  _CompoundInterestAmountState createState() => _CompoundInterestAmountState();
}

class _CompoundInterestAmountState extends State<CompoundInterestAmount> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _compoundingController = TextEditingController();
  double _futureAmount = 0.0;

  void _calculateFutureAmount() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double rate = (double.tryParse(_rateController.text) ?? 0.0) / 100;
    double time = double.tryParse(_timeController.text) ?? 0.0;
    double n = double.tryParse(_compoundingController.text) ?? 1.0; // Número de veces que se capitaliza por año

    setState(() {
      _futureAmount = principal * pow((1 + rate / n), n * time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Interés Compuesto - Monto Futuro'),
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
                    labelText: 'Tasa de Interés (%) (R)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _timeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tiempo (años) (T)',
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
                  onPressed: _calculateFutureAmount,
                  child: Text('Calcular Monto Futuro'),
                ),
                SizedBox(height: 24),
                Text(
                  'Monto Futuro (A): ${_futureAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
