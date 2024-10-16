import 'package:flutter/material.dart';
import 'dart:math';

class BonosScreen extends StatefulWidget {
  @override
  _BonosScreenState createState() => _BonosScreenState();
}

class _BonosScreenState extends State<BonosScreen> {
  final TextEditingController _couponRateController = TextEditingController();
  final TextEditingController _yearsToMaturityController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  double _bondPrice = 0.0;
  double _ytmResult = 0.0;
  bool _isCalculating = false;

  void _calculateBondPrice() {
    double couponRate = double.tryParse(_couponRateController.text) ?? 0.0;
    int years = int.tryParse(_yearsToMaturityController.text) ?? 0;
    double discountRate = (double.tryParse(_discountRateController.text) ?? 0.0) / 100;
    double couponPayment = 1000 * (couponRate / 100);

    double price = 0.0;
    for (int t = 1; t <= years; t++) {
      price += couponPayment / pow(1 + discountRate, t);
    }
    price += 1000 / pow(1 + discountRate, years);

    setState(() {
      _bondPrice = price;
    });
  }

  double _calculateYTM() {
    double couponRate = double.tryParse(_couponRateController.text) ?? 0.0;
    double couponPayment = 1000 * (couponRate / 100);
    int years = int.tryParse(_yearsToMaturityController.text) ?? 0;

    double low = 0.0, high = 1.0, mid;
    while (high - low > 0.00001) {
      mid = (low + high) / 2;
      double npv = 0.0;

      for (int t = 1; t <= years; t++) {
        npv += couponPayment / pow(1 + mid, t);
      }
      npv += 1000 / pow(1 + mid, years);

      if (npv > _bondPrice) {
        low = mid;
      } else {
        high = mid;
      }
    }
    return (low + high) / 2 * 100;
  }

  void _showResult() {
    setState(() {
      _isCalculating = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _calculateBondPrice();
        _ytmResult = _calculateYTM();
        _isCalculating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculo de Bonos'),
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
                      'Ingrese los Detalles del Bono',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildTextField(_couponRateController, 'Tasa de Cupón (%)'),
                    SizedBox(height: 8),
                    _buildTextField(_yearsToMaturityController, 'Años al Vencimiento'),
                    SizedBox(height: 8),
                    _buildTextField(_discountRateController, 'Tasa de Descuento (%)'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showResult,
              child: _isCalculating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Calcular Precio y YTM'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildResultsCard(),
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

  Widget _buildResultsCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resultados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Precio del Bono: \$${_bondPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Rendimiento al Vencimiento (YTM): ${_ytmResult.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
