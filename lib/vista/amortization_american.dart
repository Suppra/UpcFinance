import 'package:flutter/material.dart';

class AmortizationAmerican extends StatefulWidget {
  @override
  _AmortizationAmericanState createState() => _AmortizationAmericanState();
}

class _AmortizationAmericanState extends State<AmortizationAmerican> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  List<AmortizationSchedule> _schedule = [];
  double _finalPayment = 0.0;

  // Método para calcular la amortización americana
  void _calculateAmortization() {
    double principal = double.tryParse(_principalController.text) ?? 0.0;
    double annualRate = (double.tryParse(_rateController.text) ?? 0.0) / 100;
    int periods = int.tryParse(_timeController.text) ?? 0;

    if (principal <= 0 || annualRate < 0 || periods <= 0) {
      _showAlertDialog('Por favor, ingrese valores válidos.');
      return;
    }

    double monthlyRate = annualRate / 12;
    double interestPayment = principal * monthlyRate;
    List<AmortizationSchedule> tempSchedule = [];

    for (int i = 1; i < periods; i++) {
      tempSchedule.add(
        AmortizationSchedule(
          period: i,
          payment: interestPayment,
          capital: 0.0,
          interest: interestPayment,
          remainingPrincipal: principal,
        ),
      );
    }

    tempSchedule.add(
      AmortizationSchedule(
        period: periods,
        payment: interestPayment + principal,
        capital: principal,
        interest: interestPayment,
        remainingPrincipal: 0.0,
      ),
    );

    setState(() {
      _schedule = tempSchedule;
      _finalPayment = interestPayment + principal;
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
        columns: [
          _buildDataColumn('Periodo'),
          _buildDataColumn('Pago'),
          _buildDataColumn('Capital'),
          _buildDataColumn('Interés'),
          _buildDataColumn('Principal Restante'),
        ],
        rows: _schedule.map((entry) {
          return DataRow(cells: [
            _buildDataCell(entry.period.toString()),
            _buildDataCell('\$${entry.payment.toStringAsFixed(2)}'),
            _buildDataCell('\$${entry.capital.toStringAsFixed(2)}'),
            _buildDataCell('\$${entry.interest.toStringAsFixed(2)}'),
            _buildDataCell('\$${entry.remainingPrincipal.toStringAsFixed(2)}'),
          ]);
        }).toList(),
      ),
    );
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(label, style: _tableHeaderStyle()),
    );
  }

  DataCell _buildDataCell(String value) {
    return DataCell(
      Text(value, style: _tableCellStyle()),
    );
  }

  TextStyle _tableHeaderStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
  }

  TextStyle _tableCellStyle() {
    return TextStyle(fontSize: 16, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBackButton(),
                    SizedBox(height: 20),
                    _buildHeader(),  // Llamada al encabezado
                    SizedBox(height: 30),
                    _buildInputField(
                      'Capital Inicial (P)', _principalController, Icons.monetization_on_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      'Tasa de Interés Anual (%) (i)', _rateController, Icons.percent,
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      'Tiempo (meses) (n)', _timeController, Icons.timer,
                    ),
                    SizedBox(height: 32),
                    _buildCalculateButton(),
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

  Widget _buildBackground() {
    return Container(
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
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.table_chart, color: Colors.white, size: 30),
        SizedBox(width: 10),
        Text(
          'Amortización Americana',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon) {
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
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildCalculateButton() {
    return ElevatedButton(
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
        style: TextStyle(fontSize: 18, color: Colors.green.shade700),
      ),
    );
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
