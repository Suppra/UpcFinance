import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/user_balance.dart';
import '../models/loan.dart';

class LoanStatusPage extends StatefulWidget {
  @override
  _LoanStatusPageState createState() => _LoanStatusPageState();
}

class _LoanStatusPageState extends State<LoanStatusPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _paymentController = TextEditingController(); // Controlador para el campo de pago
  double _paymentAmount = 0.0; // Monto del pago ingresado por el usuario

  @override
  void dispose() {
    _paymentController.dispose(); // Liberar el controlador al cerrar la página
    super.dispose();
  }

  // Método para obtener el préstamo activo del usuario
  Future<Loan?> _getActiveLoan() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    // Suponiendo que el usuario solo tiene un préstamo activo
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('loans')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Loan.fromDocument(snapshot.docs.first);
    }
    return null;
  }

  // Método para realizar un pago y actualizar el balance
  Future<void> _makePayment(String loanId, double currentBalance) async {
    // Obtener el valor del campo al realizar el pago
    _paymentAmount = double.tryParse(_paymentController.text) ?? 0.0;

    if (_paymentAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingresa un monto válido para el pago.')),
      );
      return;
    }

    double newBalance = currentBalance - _paymentAmount;
    if (newBalance < 0) newBalance = 0;

    try {
      // Actualizar el balance del préstamo
      await FirebaseFirestore.instance.collection('loans').doc(loanId).update({
        'balance': newBalance,
      });

      // Registrar el pago en la subcolección 'payments'
      await FirebaseFirestore.instance
          .collection('loans')
          .doc(loanId)
          .collection('payments')
          .add({
        'amount': _paymentAmount,
        'date': Timestamp.now(),
      });

      // Actualizar el saldo ficticio del usuario
      UserBalance? userBalance = await _firestoreService.getUserBalance();
      if (userBalance != null) {
        double updatedBalance = userBalance.balance - _paymentAmount;
        if (updatedBalance < 0) updatedBalance = 0;
        await _firestoreService.updateUserBalance(updatedBalance);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pago realizado con éxito.')),
      );

      setState(() {
        _paymentController.clear(); // Limpiar el campo de pago después de realizar el pago
      });
    } catch (e) {
      // Manejo de errores
      print('Error al realizar el pago: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar el pago. Inténtalo de nuevo.')),
      );
    }
  }

  // Método para consultar el saldo ficticio
  Future<UserBalance?> _getUserBalance() async {
    return await _firestoreService.getUserBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento de Préstamo'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Loan?>(
        future: _getActiveLoan(),
        builder: (context, loanSnapshot) {
          if (loanSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          Loan? loan = loanSnapshot.data;
          if (loan == null) {
            return Center(
              child: Text('No tienes un préstamo activo en este momento.'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Información del préstamo
                Text(
                  'Monto del préstamo: \$${loan.amount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Tasa de interés: ${loan.interestRate.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Plazo: ${loan.term} meses',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),

                // Mostrar el saldo ficticio
                FutureBuilder<UserBalance?>(
                  future: _getUserBalance(),
                  builder: (context, balanceSnapshot) {
                    if (balanceSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (balanceSnapshot.hasError) {
                      return Text(
                        'Error al cargar el saldo ficticio.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                      );
                    }

                    if (!balanceSnapshot.hasData || balanceSnapshot.data == null) {
                      return Text(
                        'Saldo Ficticio: \$0.00',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    }

                    double userBalance = balanceSnapshot.data!.balance;
                    return Text(
                      'Saldo Ficticio: \$${userBalance.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                SizedBox(height: 20),

                // Saldo pendiente del préstamo
                Text(
                  'Balance pendiente: \$${loan.balance.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),

                // Campo para ingresar el monto del pago
                TextField(
                  controller: _paymentController, // Utiliza el controlador para manejar el texto
                  decoration: InputDecoration(
                    labelText: 'Monto del Pago',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),

                SizedBox(height: 20),

                // Botón para realizar el pago
                ElevatedButton(
                  onPressed: () {
                    _makePayment(loan.id, loan.balance);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Color del botón
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Realizar Pago',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 30),

                // Historial de Pagos
                Text(
                  'Historial de Pagos:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('loans')
                        .doc(loan.id)
                        .collection('payments')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, paymentSnapshot) {
                      if (paymentSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (paymentSnapshot.hasError) {
                        return Center(
                          child: Text('Error al cargar los pagos.'),
                        );
                      }

                      if (!paymentSnapshot.hasData || paymentSnapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('No hay pagos realizados aún.'),
                        );
                      }

                      final payments = paymentSnapshot.data!.docs;

                      return ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          var payment = payments[index];
                          double amount = payment['amount'];
                          Timestamp timestamp = payment['date'];
                          DateTime date = timestamp.toDate();

                          return ListTile(
                            leading: Icon(Icons.payment, color: Colors.green),
                            title: Text('Pago de \$${amount.toStringAsFixed(2)}'),
                            subtitle: Text('Fecha: ${date.day}/${date.month}/${date.year}'),
                          );
                        },
                      );
                    },
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
