import 'package:flutter/material.dart';
import 'dart:math';

class TIRScreen extends StatefulWidget {
  @override
  _TIRScreenState createState() => _TIRScreenState();
}

class _TIRScreenState extends State<TIRScreen> {
  final List<TextEditingController> _cashFlowControllers = [];
  final TextEditingController _initialInvestmentController = TextEditingController();
  double _tirResult = 0.0;
  bool _isCalculating = false;

  void _addCashFlowField() {
    setState(() {
      _cashFlowControllers.add(TextEditingController());
    });
  }

  void _clearFields() {
    setState(() {
      _cashFlowControllers.clear();
      _initialInvestmentController.clear();
      _tirResult = 0.0;
    });
  }

  /// Método mejorado para calcular TIR usando búsqueda binaria.
 double _calculateTIR(List<double> cashFlows) {
  double low = -1.0;
  double high = 1.0;
  double mid = 0.0; // Inicialización segura de 'mid'.

  while ((high - low).abs() > 0.00001) {
    mid = (low + high) / 2;
    double npv = _calculateNPV(cashFlows, mid);

    if (npv > 0) {
      low = mid;
    } else {
      high = mid;
    }
  }

  return mid * 100; // Retornamos la TIR como porcentaje.
}


  /// Calcula el Valor Presente Neto (VPN) para un supuesto TIR.
  double _calculateNPV(List<double> cashFlows, double rate) {
    double npv = 0.0;
    for (int t = 0; t < cashFlows.length; t++) {
      npv += cashFlows[t] / pow(1 + rate, t);
    }
    return npv;
  }

  void _showResult() {
    setState(() {
      _isCalculating = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      List<double> cashFlows = _cashFlowControllers
          .map((controller) => double.tryParse(controller.text) ?? 0.0)
          .toList();

      double initialInvestment = double.tryParse(_initialInvestmentController.text) ?? 0.0;
      cashFlows.insert(0, -initialInvestment); // Inversión inicial negativa.

      setState(() {
        _tirResult = _calculateTIR(cashFlows);
        _isCalculating = false;
      });
    });
  }

  Widget _buildSummary() {
    if (_cashFlowControllers.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flujos Ingresados:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        ..._cashFlowControllers.asMap().entries.map((entry) {
          int index = entry.key;
          String value = entry.value.text;
          return Text(
            'Flujo ${index + 1}: \$${value.isEmpty ? '0.00' : value}',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          );
        }).toList(),
        SizedBox(height: 10),
        Text(
          'TIR Calculada: ${_tirResult.toStringAsFixed(2)}%',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasa Interna de Retorno (TIR)'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      'Ingrese la Inversión Inicial',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _initialInvestmentController,
                      decoration: InputDecoration(
                        labelText: 'Inversión Inicial',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _cashFlowControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextField(
                      controller: _cashFlowControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Flujo de Caja ${index + 1}',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _addCashFlowField,
                  icon: Icon(Icons.add),
                  label: Text('Agregar Flujo de Caja'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _clearFields,
                  icon: Icon(Icons.clear),
                  label: Text('Limpiar Campos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showResult,
              child: _isCalculating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Calcular TIR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildSummary(),
          ],
        ),
      ),
    );
  }
}
