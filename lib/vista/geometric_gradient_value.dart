// archivo: lib/vista/geometric_gradient_value.dart

import 'package:flutter/material.dart';
import 'dart:math';

class GeometricGradientValue extends StatefulWidget {
  @override
  _GeometricGradientValueState createState() => _GeometricGradientValueState();
}

class _GeometricGradientValueState extends State<GeometricGradientValue> {
  final TextEditingController _initialPaymentController = TextEditingController();
  final TextEditingController _growthRateController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  final TextEditingController _numberOfPeriodsController = TextEditingController();
  
  double _presentValue = 0.0;
  double _futureValue = 0.0;

  void _calculateValues() {
    double initialPayment = double.tryParse(_initialPaymentController.text) ?? 0.0;
    double growthRate = (double.tryParse(_growthRateController.text) ?? 0.0) / 100;
    double discountRate = (double.tryParse(_discountRateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_numberOfPeriodsController.text) ?? 0;

    setState(() {
      if (discountRate != growthRate) {
        _presentValue = (initialPayment / discountRate) + (growthRate / pow(discountRate, 2)) * (1 - 1 / pow(1 + discountRate, periods));
        _futureValue = (initialPayment * pow(1 + growthRate, periods) - initialPayment) / growthRate + (initialPayment * growthRate * (pow(1 + growthRate, periods) - 1)) / pow(growthRate, 2);
      } else {
        // Fórmula alternativa cuando discountRate == growthRate
        _presentValue = initialPayment * periods * pow(1 + discountRate, periods - 1);
        _futureValue = initialPayment * periods * pow(1 + growthRate, periods);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gradiente Geométrico - Valor Presente/Futuro'),
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
                  controller: _growthRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tasa de Crecimiento (%) (g)',
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
