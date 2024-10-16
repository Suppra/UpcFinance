import 'package:flutter/material.dart';

class SimpleInterestTime extends StatefulWidget {
  @override
  _SimpleInterestTimeState createState() => _SimpleInterestTimeState();
}

class _SimpleInterestTimeState extends State<SimpleInterestTime> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _futureAmountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  double _time = 0.0;

  void _calculateTime() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double futureAmount = double.tryParse(_futureAmountController.text) ?? 0.0;
    double rate = double.tryParse(_rateController.text) ?? 0.0;

    setState(() {
      if (principal != 0 && rate != 0) {
        _time = ((futureAmount / principal) - 1) / (rate / 100);
      } else {
        _time = 0.0;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botón elegante para regresar al Menú Principal (Parte superior)
                  _buildBackButton(),
                  SizedBox(height: 20),
                  // Encabezado
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text(
                        'Interés Simple - Tiempo',
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
                  // Campo: Tasa de Interés (R)
                  _buildTextField(
                    label: 'Tasa de Interés (%) (R)',
                    controller: _rateController,
                    icon: Icons.percent,
                  ),
                  SizedBox(height: 32),
                  // Botón de Cálculo
                  ElevatedButton(
                    onPressed: _calculateTime,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Calcular Tiempo',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Resultado del Tiempo
                  Center(
                    child: Text(
                      'Tiempo (T): ${_time.toStringAsFixed(2)} años',
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

  // Método para crear el nuevo botón de regreso elegante
  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/userMenu'),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}
