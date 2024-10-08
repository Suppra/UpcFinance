// archivo: lib/vista/geometric_gradient_series.dart

import 'package:flutter/material.dart';
import 'dart:math';

class GeometricGradientSeries extends StatefulWidget {
  @override
  _GeometricGradientSeriesState createState() => _GeometricGradientSeriesState();
}

class _GeometricGradientSeriesState extends State<GeometricGradientSeries> {
  final TextEditingController _presentValueController = TextEditingController();
  final TextEditingController _futureValueController = TextEditingController();
  final TextEditingController _growthRateController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  final TextEditingController _numberOfPeriodsController = TextEditingController();

  double _seriesValue = 0.0;

  void _calculateSeriesValue() {
    double presentValue = double.tryParse(_presentValueController.text) ?? 0.0;
    double futureValue = double.tryParse(_futureValueController.text) ?? 0.0;
    double growthRate = (double.tryParse(_growthRateController.text) ?? 0.0) / 100;
    double discountRate = (double.tryParse(_discountRateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_numberOfPeriodsController.text) ?? 0;

    setState(() {
      if (discountRate != growthRate) {
        _seriesValue = presentValue + (growthRate / pow(discountRate, 2)) * (1 - 1 / pow(1 + discountRate, periods));
      } else {
        // Fórmula alternativa cuando discountRate == growthRate
        _seriesValue = presentValue + growthRate * (pow(1 + discountRate, periods) - 1) / discountRate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gradiente Geométrico - Valor de la Serie'),
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
