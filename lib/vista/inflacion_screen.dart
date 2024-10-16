import 'package:flutter/material.dart';
import 'dart:math';

class InflacionScreen extends StatefulWidget {
  @override
  _InflacionScreenState createState() => _InflacionScreenState();
}

class _InflacionScreenState extends State<InflacionScreen> {
  final TextEditingController _initialAmountController = TextEditingController();
  final TextEditingController _inflationRateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  double _futureValue = 0.0;
  bool _isCalculating = false;

  void _calculateFutureValue() {
    double initialAmount = double.tryParse(_initialAmountController.text) ?? 0.0;
    double inflationRate = (double.tryParse(_inflationRateController.text) ?? 0.0) / 100;
    int years = int.tryParse(_yearsController.text) ?? 0;

    double futureValue = initialAmount * pow(1 + inflationRate, years);

    setState(() {
      _futureValue = futureValue;
    });
  }

  void _clearFields() {
    setState(() {
      _initialAmountController.clear();
      _inflationRateController.clear();
      _yearsController.clear();
      _futureValue = 0.0;
    });
  }

  Widget _buildComparisonCard(double otherRate, String label) {
    double initialAmount = double.tryParse(_initialAmountController.text) ?? 0.0;
    int years = int.tryParse(_yearsController.text) ?? 0;
    double otherFutureValue = initialAmount * pow(1 + otherRate / 100, years);

    return Card(
      color: Colors.green.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              '$label a $otherRate%',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800),
            ),
            SizedBox(height: 5),
            Text(
              'Valor Futuro: \$${otherFutureValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculo de Inflación'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildTextField(_initialAmountController, 'Monto Inicial'),
                    SizedBox(height: 10),
                    _buildTextField(_inflationRateController, 'Tasa de Inflación (%)'),
                    SizedBox(height: 10),
                    _buildTextField(_yearsController, 'Años'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _calculateFutureValue,
                  icon: Icon(Icons.calculate),
                  label: Text('Calcular'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _clearFields,
                  icon: Icon(Icons.clear),
                  label: Text('Limpiar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Valor Futuro: \$${_futureValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildComparisonCard(3.0, 'Tasa Alternativa'),
                  _buildComparisonCard(5.0, 'Escenario Optimista'),
                  _buildComparisonCard(10.0, 'Escenario Pesimista'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }
}
