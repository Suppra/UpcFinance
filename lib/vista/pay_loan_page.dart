import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PayLoanPage extends StatefulWidget {
  final String loanId;

  PayLoanPage({required this.loanId});

  @override
  _PayLoanPageState createState() => _PayLoanPageState();
}

class _PayLoanPageState extends State<PayLoanPage> {
  final _formKey = GlobalKey<FormState>();
  double paymentAmount = 0.0;
  bool isLoading = false;

  Future<void> _makePayment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() { isLoading = true; });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No estás autenticado.')),
          );
          return;
        }

        DocumentReference loanRef = FirebaseFirestore.instance.collection('loans').doc(widget.loanId);
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot loanSnapshot = await transaction.get(loanRef);
          DocumentSnapshot userSnapshot = await transaction.get(userRef);

          if (!loanSnapshot.exists || !userSnapshot.exists) {
            throw Exception('Préstamo o usuario no encontrado.');
          }

          double currentLoanBalance = loanSnapshot.get('balance') ?? 0.0;
          double newLoanBalance = currentLoanBalance - paymentAmount;

          if (newLoanBalance < 0) {
            throw Exception('El monto del pago excede el saldo del préstamo.');
          }

          double currentUserBalance = userSnapshot.get('balance') ?? 0.0;
          double newUserBalance = currentUserBalance - paymentAmount;

          // Actualizar el saldo del préstamo y del usuario
          transaction.update(loanRef, {'balance': newLoanBalance});
          transaction.update(userRef, {'balance': newUserBalance});
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pago realizado correctamente.')),
        );

        Navigator.pop(context); // Regresar a la página anterior
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al realizar el pago: $e')),
        );
      } finally {
        setState(() { isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Pago'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Monto a Pagar'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  paymentAmount = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Ingresa un monto válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _makePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
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
            ],
          ),
        ),
      ),
    );
  }
}
