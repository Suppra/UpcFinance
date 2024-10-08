import 'dart:math'; // Importa dart:math para poder usar .pow()
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
  String loanType = 'Interés Simple'; // Valor por defecto

  // Lista de opciones para el tipo de interés/amortización
  final List<String> loanTypes = [
    'Interés Simple',
    'Interés Compuesto',
    'Gradiente Aritmético',
    'Gradiente Geométrico',
    'Amortización Alemana',
    'Amortización Francesa',
    'Amortización Americana',
  ];

  // Método para solicitar un préstamo
  Future<void> _requestLoan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario no autenticado.')),
        );
        return;
      }

      // Realizar el cálculo según el tipo de préstamo seleccionado
      double calculatedAmount = _calculateLoanAmount();

      Loan newLoan = Loan(
        id: '', // Se asignará automáticamente por Firestore
        userId: user.uid,
        amount: calculatedAmount, // Monto calculado
        term: loanTerm,
        interestRate: interestRate,
        requestDate: DateTime.now(),
        balance: calculatedAmount, // Balance inicial igual al monto calculado
        loanType: loanType, // Tipo de préstamo seleccionado
      );

      try {
        // Solicitar el préstamo a través del servicio
        await _firestoreService.requestLoan(newLoan);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Préstamo solicitado con éxito.')),
        );

        Navigator.pop(context); // Regresar a la página anterior
      } catch (e) {
        print('Error al solicitar el préstamo: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al solicitar el préstamo. Inténtalo de nuevo.')),
        );
      }
    }
  }

  // Método para calcular el monto del préstamo según el tipo seleccionado
  double _calculateLoanAmount() {
    double calculatedAmount = loanAmount;

    switch (loanType) {
      case 'Interés Simple':
        calculatedAmount = loanAmount * (1 + (interestRate / 100) * loanTerm);
        break;
      case 'Interés Compuesto':
        // Usamos dart:math para calcular la potencia
        calculatedAmount = loanAmount * pow(1 + (interestRate / 100), loanTerm);
        break;
      case 'Gradiente Aritmético':
        // Lógica para calcular con Gradiente Aritmético
        break;
      case 'Gradiente Geométrico':
        // Lógica para calcular con Gradiente Geométrico
        break;
      case 'Amortización Alemana':
        // Lógica para Amortización Alemana
        break;
      case 'Amortización Francesa':
        // Lógica para Amortización Francesa
        break;
      case 'Amortización Americana':
        // Lógica para Amortización Americana
        break;
    }

    return calculatedAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Préstamo'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Monto del préstamo
              TextFormField(
                decoration: InputDecoration(labelText: 'Monto del Préstamo'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  loanAmount = double.parse(value!);
                },
                validator: (value) {
                  if (value!.isEmpty || double.parse(value) <= 0) {
                    return 'Ingresa un monto válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Plazo en meses
              TextFormField(
                decoration: InputDecoration(labelText: 'Plazo en meses'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  loanTerm = int.parse(value!);
                },
                validator: (value) {
                  if (value!.isEmpty || int.parse(value) <= 0) {
                    return 'Ingresa un plazo válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Tasa de interés
              TextFormField(
                decoration: InputDecoration(labelText: 'Tasa de Interés (%)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  interestRate = double.parse(value!);
                },
                validator: (value) {
                  if (value!.isEmpty || double.parse(value) < 0) {
                    return 'Ingresa una tasa de interés válida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Tipo de préstamo
              DropdownButtonFormField<String>(
                value: loanType.isNotEmpty ? loanType : null, // Corregir el valor inicial
                items: loanTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    loanType = value ?? 'Interés Simple'; // Asegurarse de que no sea nulo
                  });
                },
                decoration: InputDecoration(labelText: 'Tipo de Préstamo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona un tipo de préstamo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              // Botón para solicitar el préstamo
              ElevatedButton(
                onPressed: _requestLoan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Color del botón
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Solicitar Préstamo',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
