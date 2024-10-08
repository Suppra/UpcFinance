// archivo: lib/vista/arithmetic_gradient_series.dart

import 'package:flutter/material.dart';
import 'dart:math';

class ArithmeticGradientSeries extends StatefulWidget {
  @override
  _ArithmeticGradientSeriesState createState() => _ArithmeticGradientSeriesState();
}

class _ArithmeticGradientSeriesState extends State<ArithmeticGradientSeries> {
  final TextEditingController _presentValueController = TextEditingController();
  final TextEditingController _futureValueController = TextEditingController();
  final TextEditingController _gradientController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  final TextEditingController _numberOfPeriodsController = TextEditingController();

  double _seriesValue = 0.0;

  void _calculateSeriesValue() {
    double presentValue = double.tryParse(_presentValueController.text) ?? 0.0;
    double futureValue = double.tryParse(_futureValueController.text) ?? 0.0;
    double gradient = double.tryParse(_gradientController.text) ?? 0.0;
    double discountRate = (double.tryParse(_discountRateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_numberOfPeriodsController.text) ?? 0;

    setState(() {
      // Supongamos que queremos calcular el valor de la serie basado en el Valor Presente
      if (discountRate != 0) {
        _seriesValue = presentValue + (gradient / pow(discountRate, 2)) * (1 - 1 / pow(1 + discountRate, periods));
      } else {
        _seriesValue = presentValue + gradient * (periods * (periods - 1)) / 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gradiente Aritmético - Valor de la Serie'),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _presentValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Valor Presente (PV)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _futureValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Valor Futuro (FV)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _gradientController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Gradiente Aritmético (G)',
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
                  onPressed: _calculateSeriesValue,
                  child: Text('Calcular Valor de la Serie'),
                ),
                SizedBox(height: 24),
                Text(
                  'Valor de la Serie (SV): ${_seriesValue.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
