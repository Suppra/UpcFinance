import 'package:flutter/material.dart';
import 'dart:math';

class GeometricGradientSeries extends StatefulWidget {
  @override
  _GeometricGradientSeriesState createState() =>
      _GeometricGradientSeriesState();
}

class _GeometricGradientSeriesState extends State<GeometricGradientSeries> {
  final TextEditingController _presentValueController = TextEditingController();
  final TextEditingController _futureValueController = TextEditingController();
  final TextEditingController _growthRateController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  final TextEditingController _numberOfPeriodsController =
      TextEditingController();

  double _seriesValue = 0.0;

  void _calculateSeriesValue() {
    double presentValue = double.tryParse(_presentValueController.text) ?? 0.0;
    double growthRate =
        (double.tryParse(_growthRateController.text) ?? 0.0) / 100;
    double discountRate =
        (double.tryParse(_discountRateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_numberOfPeriodsController.text) ?? 0;

    setState(() {
      if (discountRate != growthRate) {
        _seriesValue = presentValue +
            (growthRate / pow(discountRate, 2)) *
                (1 - 1 / pow(1 + discountRate, periods));
      } else {
        _seriesValue = presentValue +
            growthRate * (pow(1 + discountRate, periods) - 1) / discountRate;
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
                        Icon(Icons.show_chart, color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Gradiente Geométrico - Valor de la Serie',
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
                      label: 'Valor Presente (PV)',
                      controller: _presentValueController,
                      icon: Icons.monetization_on_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Valor Futuro (FV)',
                      controller: _futureValueController,
                      icon: Icons.attach_money,
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
                    // Resultado
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

  // Campo de texto personalizado
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
