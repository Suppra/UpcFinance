// archivo: lib/vista/amortization_german.dart

import 'package:flutter/material.dart';
import 'dart:math';

class AmortizationGerman extends StatefulWidget {
  @override
  _AmortizationGermanState createState() => _AmortizationGermanState();
}

class _AmortizationGermanState extends State<AmortizationGerman> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<AmortizationSchedule> _schedule = [];

  void _calculateAmortization() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double annualRate = (double.tryParse(_rateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_timeController.text) ?? 0;

    if (principal <= 0 || annualRate < 0 || periods <= 0) {
      _showAlertDialog('Por favor, ingrese valores válidos.');
      return;
    }

    double capitalPerPeriod = principal / periods;
    double remainingPrincipal = principal;
    List<AmortizationSchedule> tempSchedule = [];

    for (int i = 1; i <= periods; i++) {
      double interest = remainingPrincipal * (annualRate / 12); // Pagos mensuales
      double payment = capitalPerPeriod + interest;
      remainingPrincipal -= capitalPerPeriod;

      tempSchedule.add(AmortizationSchedule(
        period: i,
        payment: payment,
        capital: capitalPerPeriod,
        interest: interest,
        remainingPrincipal: remainingPrincipal < 0 ? 0 : remainingPrincipal,
      ));
    }

    setState(() {
      _schedule = tempSchedule;
    });
  }

  Future<void> _showAlertDialog(String message) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alerta'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTable() {
    if (_schedule.isEmpty) {
      return Center(
        child: Text(
          'No hay cálculos para mostrar.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: [
          DataColumn(label: Text('Periodo', style: _tableHeaderStyle())),
          DataColumn(label: Text('Pago', style: _tableHeaderStyle())),
          DataColumn(label: Text('Capital', style: _tableHeaderStyle())),
          DataColumn(label: Text('Interés', style: _tableHeaderStyle())),
          DataColumn(label: Text('Principal Restante', style: _tableHeaderStyle())),
        ],
        rows: _schedule.map((entry) {
          return DataRow(
            cells: [
              DataCell(Text(entry.period.toString(), style: _tableCellStyle())),
              DataCell(Text('\$${entry.payment.toStringAsFixed(2)}', style: _tableCellStyle())),
              DataCell(Text('\$${entry.capital.toStringAsFixed(2)}', style: _tableCellStyle())),
              DataCell(Text('\$${entry.interest.toStringAsFixed(2)}', style: _tableCellStyle())),
              DataCell(Text('\$${entry.remainingPrincipal.toStringAsFixed(2)}', style: _tableCellStyle())),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con degradado y opacidad
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
                    Row(
                      children: [
                        Icon(Icons.table_chart, color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Amortización Alemán',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                      label: 'Capital Inicial (P)',
                      controller: _principalController,
                      icon: Icons.monetization_on_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Tasa de Interés Anual (%) (i)',
                      controller: _rateController,
                      icon: Icons.percent,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Tiempo (meses) (n)',
                      controller: _timeController,
                      icon: Icons.timer,
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _calculateAmortization,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Calcular Amortización',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildScheduleTable(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
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

  TextStyle _tableHeaderStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
  }

  TextStyle _tableCellStyle() {
    return TextStyle(fontSize: 16, color: Colors.white);
  }
}

class AmortizationSchedule {
  final int period;
  final double payment;
  final double capital;
  final double interest;
  final double remainingPrincipal;

  AmortizationSchedule({
    required this.period,
    required this.payment,
    required this.capital,
    required this.interest,
    required this.remainingPrincipal,
  });
}
