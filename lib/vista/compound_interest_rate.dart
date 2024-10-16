// archivo: lib/vista/compound_interest_rate.dart

import 'package:flutter/material.dart';
import 'dart:math';

class CompoundInterestRate extends StatefulWidget {
  @override
  _CompoundInterestRateState createState() => _CompoundInterestRateState();
}

class _CompoundInterestRateState extends State<CompoundInterestRate> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _futureAmountController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _compoundingController = TextEditingController();
  double _interestRate = 0.0;

  void _calculateInterestRate() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double futureAmount = double.tryParse(_futureAmountController.text) ?? 0.0;
    double time = double.tryParse(_timeController.text) ?? 0.0;
    double n = double.tryParse(_compoundingController.text) ?? 1.0;

    double lower = 0.0;
    double upper = 1.0;
    double rate = 0.0;
    double epsilon = 0.0001;
    int maxIterations = 1000;
    int iterations = 0;

    while (iterations < maxIterations) {
      rate = (lower + upper) / 2;
      double calculatedAmount = principal * pow((1 + rate / n), n * time);

      if ((calculatedAmount - futureAmount).abs() < epsilon) {
        break;
      } else if (calculatedAmount < futureAmount) {
        lower = rate;
      } else {
        upper = rate;
      }

      iterations++;
    }

    setState(() {
      _interestRate = rate * 100; // Convertir a porcentaje
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
                    // Botón para regresar al Menú Principal
                    _buildBackButton(),
                    SizedBox(height: 20),
                    // Encabezado
                    Row(
                      children: [
                        Icon(Icons.percent, color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Interés Compuesto - Tasa',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Campo: Capital Inicial (P)
                    _buildTextField(
                      label: 'Capital Inicial (P)',
                      controller: _principalController,
                      icon: Icons.monetization_on_outlined,
                    ),
                    SizedBox(height: 16),
                    // Campo: Monto Futuro (A)
                    _buildTextField(
                      label: 'Monto Futuro (A)',
                      controller: _futureAmountController,
                      icon: Icons.attach_money,
                    ),
                    SizedBox(height: 16),
                    // Campo: Tiempo (T)
                    _buildTextField(
                      label: 'Tiempo (años) (T)',
                      controller: _timeController,
                      icon: Icons.access_time,
                    ),
                    SizedBox(height: 16),
                    // Campo: Número de Capitalizaciones (n)
                    _buildTextField(
                      label: 'Capitalizaciones por Año (n)',
                      controller: _compoundingController,
                      icon: Icons.repeat,
                    ),
                    SizedBox(height: 32),
                    // Botón de Cálculo
                    ElevatedButton(
                      onPressed: _calculateInterestRate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Calcular Tasa de Interés',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Resultado de la Tasa de Interés
                    Center(
                      child: Text(
                        'Tasa de Interés (R): ${_interestRate.toStringAsFixed(2)}%',
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

  // Método para crear el botón de regreso elegante
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
