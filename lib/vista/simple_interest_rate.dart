// archivo: lib/vista/simple_interest_rate.dart

import 'package:flutter/material.dart';

class SimpleInterestRate extends StatefulWidget {
  @override
  _SimpleInterestRateState createState() => _SimpleInterestRateState();
}

class _SimpleInterestRateState extends State<SimpleInterestRate> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _futureAmountController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  double _interestRate = 0.0;

  void _calculateInterestRate() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double futureAmount = double.tryParse(_futureAmountController.text) ?? 0.0;
    double time = double.tryParse(_timeController.text) ?? 0.0;

    setState(() {
      if (principal != 0 && time != 0) {
        _interestRate = ((futureAmount / principal) - 1) / time * 100;
      } else {
        _interestRate = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Interés Simple - Tasa de Interés'),
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
