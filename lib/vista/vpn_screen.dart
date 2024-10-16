import 'package:flutter/material.dart';
import 'dart:math';

class VPNScreen extends StatefulWidget {
  @override
  _VPNScreenState createState() => _VPNScreenState();
}

class _VPNScreenState extends State<VPNScreen> {
  final List<TextEditingController> _cashFlowControllers = [];
  final TextEditingController _discountRateController = TextEditingController();
  double _vpnResult = 0.0;
  bool _isCalculating = false;

  void _addCashFlowField() {
    setState(() {
      _cashFlowControllers.add(TextEditingController());
    });
  }

  void _clearFields() {
    setState(() {
      _cashFlowControllers.clear();
      _discountRateController.clear();
      _vpnResult = 0.0;
    });
  }

  double _calculateVPN() {
    double discountRate = (double.tryParse(_discountRateController.text) ?? 0) / 100;
    List<double> cashFlows = _cashFlowControllers
        .map((controller) => double.tryParse(controller.text) ?? 0.0)
        .toList();

    double vpn = 0.0;
    for (int t = 0; t < cashFlows.length; t++) {
      vpn += cashFlows[t] / pow(1 + discountRate, t);
    }

    return vpn;
  }

  void _showResult() {
    setState(() {
      _isCalculating = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _vpnResult = _calculateVPN();
        _isCalculating = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text('Resultado del VPN'),
          content: Text(
            'El VPN calculado es: \$${_vpnResult.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummary() {
    if (_cashFlowControllers.isEmpty) return SizedBox.shrink();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flujos Ingresados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            ..._cashFlowControllers.asMap().entries.map((entry) {
              int index = entry.key;
              String value = entry.value.text;
              return Text(
                'Flujo ${index + 1}: \$${value.isEmpty ? '0.00' : value}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              );
            }).toList(),
            SizedBox(height: 10),
            Text(
              'VPN: \$${_vpnResult.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
        title: Text('Evaluación de Alternativas (VPN)'),
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
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      'Ingrese la Tasa de Descuento',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _discountRateController,
                      decoration: InputDecoration(
                        labelText: 'Tasa de Descuento (%)',
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
                  label: Text('Agregar Flujo'),
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
                    backgroundColor: Colors.redAccent,
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
                  : Text('Calcular VPN'),
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
