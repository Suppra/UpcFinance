// archivo: lib/vista/geometric_gradient_value.dart

import 'package:flutter/material.dart';
import 'dart:math';

class GeometricGradientValue extends StatefulWidget {
  @override
  _GeometricGradientValueState createState() => _GeometricGradientValueState();
}

class _GeometricGradientValueState extends State<GeometricGradientValue> {
  final TextEditingController _initialPaymentController = TextEditingController();
  final TextEditingController _growthRateController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  final TextEditingController _numberOfPeriodsController = TextEditingController();

  double _presentValue = 0.0;
  double _futureValue = 0.0;

  void _calculateValues() {
    double initialPayment = double.tryParse(_initialPaymentController.text) ?? 0.0;
    double growthRate = (double.tryParse(_growthRateController.text) ?? 0.0) / 100;
    double discountRate = (double.tryParse(_discountRateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_numberOfPeriodsController.text) ?? 0;

    setState(() {
      if (discountRate != growthRate) {
        _presentValue = (initialPayment / discountRate) +
            (growthRate / pow(discountRate, 2)) *
                (1 - 1 / pow(1 + discountRate, periods));
        _futureValue = (initialPayment * pow(1 + growthRate, periods) -
                initialPayment) /
            growthRate +
            (initialPayment * growthRate * (pow(1 + growthRate, periods) - 1)) /
                pow(growthRate, 2);
      } else {
        _presentValue =
            initialPayment * periods * pow(1 + discountRate, periods - 1);
        _futureValue = initialPayment * periods * pow(1 + growthRate, periods);
      }
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
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBackButton(),
                    SizedBox(height: 20),
                    // Encabezado
                    Row(
                      children: [
                        Icon(Icons.bar_chart, color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Gradiente Geométrico',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Campos de entrada
                    _buildTextField(
                      label: 'Pago Inicial (P)',
                      controller: _initialPaymentController,
                      icon: Icons.monetization_on_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Tasa de Crecimiento (%) (g)',
                      controller: _growthRateController,
                      icon: Icons.trending_up,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Tasa de Descuento (%) (i)',
                      controller: _discountRateController,
                      icon: Icons.percent,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Número de Periodos (n)',
                      controller: _numberOfPeriodsController,
                      icon: Icons.timer,
                    ),
                    SizedBox(height: 32),
                    // Botón de cálculo
                    ElevatedButton(
                      onPressed: _calculateValues,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Calcular Valores',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Resultados
                    Center(
                      child: Text(
                        'Valor Presente (PV): ${_presentValue.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Valor Futuro (FV): ${_futureValue.toStringAsFixed(2)}',
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

  // Método para crear campos de texto personalizados
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

  // Botón de regreso elegante y minimalista
  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
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
