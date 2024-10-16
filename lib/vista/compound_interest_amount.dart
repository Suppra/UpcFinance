import 'package:flutter/material.dart';
import 'dart:math';

class CompoundInterestAmount extends StatefulWidget {
  @override
  _CompoundInterestAmountState createState() => _CompoundInterestAmountState();
}

class _CompoundInterestAmountState extends State<CompoundInterestAmount> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _compoundingController = TextEditingController();
  double _futureAmount = 0.0;

  void _calculateFutureAmount() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double rate = (double.tryParse(_rateController.text) ?? 0.0) / 100;
    double time = double.tryParse(_timeController.text) ?? 0.0;
    double n = double.tryParse(_compoundingController.text) ?? 1.0;

    setState(() {
      _futureAmount = principal * pow((1 + rate / n), n * time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen y degradado
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/finances_background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.green.withOpacity(0.6),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBackButton(),
                    SizedBox(height: 30),
                    // Encabezado
                    Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Interés Compuesto - Monto Futuro',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Campos de entrada
                    _buildTextField(
                      label: 'Capital Inicial (P)',
                      controller: _principalController,
                      icon: Icons.monetization_on_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Tasa de Interés (%) (R)',
                      controller: _rateController,
                      icon: Icons.percent,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Tiempo (años) (T)',
                      controller: _timeController,
                      icon: Icons.access_time,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Número de Capitalizaciones por Año (n)',
                      controller: _compoundingController,
                      icon: Icons.repeat,
                    ),
                    SizedBox(height: 32),
                    // Botón de cálculo
                    ElevatedButton(
                      onPressed: _calculateFutureAmount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Calcular Monto Futuro',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Resultado
                    Center(
                      child: Text(
                        'Monto Futuro (A): ${_futureAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        floatingLabelStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/userMenu'),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Menú Principal',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
