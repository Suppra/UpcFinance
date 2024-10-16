// archivo: lib/vista/arithmetic_gradient_series.dart

import 'package:flutter/material.dart';
import 'dart:math';

class ArithmeticGradientSeries extends StatefulWidget {
  @override
  _ArithmeticGradientSeriesState createState() =>
      _ArithmeticGradientSeriesState();
}

class _ArithmeticGradientSeriesState extends State<ArithmeticGradientSeries> {
  final TextEditingController _presentValueController = TextEditingController();
  final TextEditingController _futureValueController = TextEditingController();
  final TextEditingController _gradientController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  final TextEditingController _numberOfPeriodsController =
      TextEditingController();

  double _seriesValue = 0.0;

  void _calculateSeriesValue() {
    double presentValue = double.tryParse(_presentValueController.text) ?? 0.0;
    double gradient = double.tryParse(_gradientController.text) ?? 0.0;
    double discountRate =
        (double.tryParse(_discountRateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_numberOfPeriodsController.text) ?? 0;

    setState(() {
      if (discountRate != 0) {
        _seriesValue = presentValue +
            (gradient / pow(discountRate, 2)) *
                (1 - 1 / pow(1 + discountRate, periods));
      } else {
        _seriesValue =
            presentValue + gradient * (periods * (periods - 1)) / 2;
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
                    // Botón de regreso
                    _buildBackButton(),
                    SizedBox(height: 20),
                    // Encabezado
                    Row(
                      children: [
                        Icon(Icons.stacked_line_chart,
                            color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Gradiente Aritmético - Serie',
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
                      label: 'Valor Presente (PV)',
                      controller: _presentValueController,
                      icon: Icons.monetization_on_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Gradiente Aritmético (G)',
                      controller: _gradientController,
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
                    // Botón de Cálculo
                    ElevatedButton(
                      onPressed: _calculateSeriesValue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Calcular Valor de la Serie',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Resultado del valor de la serie
                    Center(
                      child: Text(
                        'Valor de la Serie (SV): ${_seriesValue.toStringAsFixed(2)}',
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

  // Botón de regreso elegante
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
