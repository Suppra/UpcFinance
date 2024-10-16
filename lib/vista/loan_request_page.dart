import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/loan.dart';

class LoanRequestPage extends StatefulWidget {
  @override
  _LoanRequestPageState createState() => _LoanRequestPageState();
}

class _LoanRequestPageState extends State<LoanRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  double loanAmount = 0.0;
  int loanTerm = 0;
  double interestRate = 0.0;
  String loanType = 'Interés Simple';
  bool isLoading = false; // Controla si la solicitud está en proceso

  final List<String> loanTypes = [
    'Interés Simple',
    'Interés Compuesto',
    'Gradiente Aritmético',
    'Gradiente Geométrico',
    'Amortización Alemana',
    'Amortización Francesa',
    'Amortización Americana',
  ];

  Future<void> _requestLoan() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() {
      isLoading = true; // Mostrar indicador de carga
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Usuario no autenticado.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      double calculatedAmount = _calculateLoanAmount();
      Loan newLoan = Loan(
        id: '',
        userId: user.uid,
        amount: calculatedAmount,
        term: loanTerm,
        interestRate: interestRate,
        requestDate: DateTime.now(),
        balance: calculatedAmount,
        loanType: loanType,
      );

      await _firestoreService.requestLoan(newLoan);
      _showMessage('Préstamo solicitado con éxito.');
      Navigator.pop(context);
    } catch (e) {
      _showMessage('Error al solicitar el préstamo. Inténtalo de nuevo.');
    } finally {
      setState(() {
        isLoading = false; // Ocultar indicador de carga
      });
    }
  }

  double _calculateLoanAmount() {
    switch (loanType) {
      case 'Interés Simple':
        return loanAmount * (1 + (interestRate / 100) * loanTerm);
      case 'Interés Compuesto':
        return loanAmount * pow(1 + (interestRate / 100), loanTerm);
      default:
        return loanAmount;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                    Text(
                      'Solicitar Préstamo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            label: 'Monto del Préstamo',
                            icon: Icons.monetization_on,
                            onSaved: (value) => loanAmount = double.parse(value!),
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'Plazo en meses',
                            icon: Icons.calendar_today,
                            onSaved: (value) => loanTerm = int.parse(value!),
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'Tasa de Interés (%)',
                            icon: Icons.percent,
                            onSaved: (value) => interestRate = double.parse(value!),
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: loanType,
                            items: loanTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                loanType = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Tipo de Préstamo',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              floatingLabelStyle: TextStyle(color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white),
                            dropdownColor: Colors.green.shade800,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    isLoading
                        ? Center(child: CircularProgressIndicator()) // Indicador de carga
                        : ElevatedButton(
                            onPressed: _requestLoan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Solicitar Préstamo',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green.shade700,
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

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text(
              'Volver',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String?) onSaved,
  }) {
    return TextFormField(
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
      keyboardType: TextInputType.number,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
    );
  }
}

