import 'package:flutter/material.dart';

class UVRScreen extends StatefulWidget {
  @override
  _UVRScreenState createState() => _UVRScreenState();
}

class _UVRScreenState extends State<UVRScreen> {
  final TextEditingController _uvrValueController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  double _convertedAmount = 0.0;
  bool _isCalculating = false;

  void _calculateUVR() {
    setState(() {
      _isCalculating = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      double uvr = double.tryParse(_uvrValueController.text) ?? 0.0;
      double amount = double.tryParse(_amountController.text) ?? 0.0;

      if (uvr <= 0 || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, ingresa valores válidos.')),
        );
      } else {
        setState(() {
          _convertedAmount = amount * uvr;
          _isCalculating = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text('Resultado'),
            content: Text(
              'Monto en UVR: \$${_convertedAmount.toStringAsFixed(2)}',
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
      }
    });
  }

  void _clearFields() {
    setState(() {
      _uvrValueController.clear();
      _amountController.clear();
      _convertedAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unidad de Valor Real (UVR)'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputCard(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _calculateUVR,
                  icon: Icon(Icons.calculate),
                  label: _isCalculating
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Calcular'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _clearFields,
                  icon: Icon(Icons.clear),
                  label: Text('Limpiar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            _buildResultSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
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
              'Ingresa los Valores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _uvrValueController,
              label: 'Valor UVR',
              icon: Icons.attach_money,
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _amountController,
              label: 'Monto',
              icon: Icons.account_balance_wallet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.black),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildResultSummary() {
    if (_convertedAmount == 0.0) return SizedBox.shrink();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.green.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Resultado del Cálculo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Monto en UVR: \$${_convertedAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
