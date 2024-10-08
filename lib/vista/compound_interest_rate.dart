// archivo: lib/vista/compound_interest_rate.dart

import 'package:flutter/material.dart';
import 'dart:math';

class CompoundInterestRate extends StatefulWidget {
  @override
  _CompoundInterestRateState createState() => _CompoundInterestRateState();
}

class _CompoundInterestRateState extends State<CompoundInterestRate> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _futureAmountController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _compoundingController = TextEditingController();
  double _interestRate = 0.0;

  void _calculateInterestRate() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double futureAmount = double.tryParse(_futureAmountController.text) ?? 0.0;
    double time = double.tryParse(_timeController.text) ?? 0.0;
    double n = double.tryParse(_compoundingController.text) ?? 1.0;

    // Usar una aproximación numérica (como la bisección) para resolver A = P * (1 + r/n)^(n*t)
    // Para simplificar, usaremos un enfoque iterativo

    double lower = 0.0;
    double upper = 1.0;
    double rate = 0.0;
    double epsilon = 0.0001;
    int maxIterations = 1000;
    int iterations = 0;

    while (iterations < maxIterations) {
      rate = (lower + upper) / 2;
      double calculatedAmount = principal * pow((1 + rate / n), n * time);

      if ((calculatedAmount - futureAmount).abs() < epsilon) {
        break;
      } else if (calculatedAmount < futureAmount) {
        lower = rate;
      } else {
        upper = rate;
      }

      iterations++;
    }

    setState(() {
      _interestRate = rate * 100; // Convertir a porcentaje
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Interés Compuesto - Tasa de Interés'),
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
                  onPressed: _calculateInterestRate,
                  child: Text('Calcular Tasa de Interés'),
                ),
                SizedBox(height: 24),
                Text(
                  'Tasa de Interés (R): ${_interestRate.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
