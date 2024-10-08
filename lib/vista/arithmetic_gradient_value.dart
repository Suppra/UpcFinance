// archivo: lib/vista/arithmetic_gradient_value.dart

import 'package:flutter/material.dart';
import 'dart:math';

class ArithmeticGradientValue extends StatefulWidget {
  @override
  _ArithmeticGradientValueState createState() => _ArithmeticGradientValueState();
}

class _ArithmeticGradientValueState extends State<ArithmeticGradientValue> {
  final TextEditingController _initialPaymentController = TextEditingController();
  final TextEditingController _gradientController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  final TextEditingController _numberOfPeriodsController = TextEditingController();
  
  double _presentValue = 0.0;
  double _futureValue = 0.0;

  void _calculateValues() {
    double initialPayment = double.tryParse(_initialPaymentController.text) ?? 0.0;
    double gradient = double.tryParse(_gradientController.text) ?? 0.0;
    double discountRate = (double.tryParse(_discountRateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_numberOfPeriodsController.text) ?? 0;

    setState(() {
      // Fórmula para Valor Presente de un gradiente aritmético
      if (discountRate != 0) {
        _presentValue = (initialPayment / discountRate) + (gradient / pow(discountRate, 2)) * (1 - 1 / pow(1 + discountRate, periods));
        _futureValue = (initialPayment * pow(1 + discountRate, periods) - initialPayment) / discountRate + (gradient * (pow(1 + discountRate, periods) - 1 - discountRate * periods)) / pow(discountRate, 2);
      } else {
        // Cuando la tasa de descuento es 0
        _presentValue = initialPayment + gradient * (periods * (periods - 1)) / 2;
        _futureValue = initialPayment * periods + gradient * (periods * (periods - 1) * (2 * periods - 1)) / 6;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gradiente Aritmético - Valor Presente/Futuro'),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _initialPaymentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Pago Inicial (P)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _gradientController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Gradiente (G)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _discountRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tasa de Descuento (%) (i)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _numberOfPeriodsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Número de Periodos (n)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateValues,
                  child: Text('Calcular Valores'),
                ),
                SizedBox(height: 24),
                Text(
                  'Valor Presente (PV): ${_presentValue.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Valor Futuro (FV): ${_futureValue.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
