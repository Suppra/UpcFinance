// archivo: lib/vista/simple_interest_amount.dart

import 'package:flutter/material.dart';

class SimpleInterestAmount extends StatefulWidget {
  @override
  _SimpleInterestAmountState createState() => _SimpleInterestAmountState();
}

class _SimpleInterestAmountState extends State<SimpleInterestAmount> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  double _futureAmount = 0.0;

  void _calculateFutureAmount() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double rate = double.tryParse(_rateController.text) ?? 0.0;
    double time = double.tryParse(_timeController.text) ?? 0.0;

    setState(() {
      _futureAmount = principal * (1 + (rate * time) / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Interés Simple - Monto Futuro'),
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
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateFutureAmount,
                  child: Text('Calcular Monto Futuro'),
                ),
                SizedBox(height: 24),
                Text(
                  'Monto Futuro (A): $_futureAmount',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
