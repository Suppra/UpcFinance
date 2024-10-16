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
  final TextEditingController _paymentController = TextEditingController();
  bool isLoading = false;

  Future<void> _makePayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          _showSnackBar('No estás autenticado.');
          return;
        }

        DocumentReference loanRef =
            FirebaseFirestore.instance.collection('loans').doc(widget.loanId);
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot loanSnapshot = await transaction.get(loanRef);
          DocumentSnapshot userSnapshot = await transaction.get(userRef);

          if (!loanSnapshot.exists || !userSnapshot.exists) {
            throw Exception('Préstamo o usuario no encontrado.');
          }

          double currentLoanBalance = loanSnapshot.get('balance') ?? 0.0;
          double paymentAmount =
              double.tryParse(_paymentController.text) ?? 0.0;
          double newLoanBalance = currentLoanBalance - paymentAmount;

          if (newLoanBalance < 0) {
            throw Exception('El monto del pago excede el saldo del préstamo.');
          }

          double currentUserBalance = userSnapshot.get('balance') ?? 0.0;
          double newUserBalance = currentUserBalance - paymentAmount;

          transaction.update(loanRef, {'balance': newLoanBalance});
          transaction.update(userRef, {'balance': newUserBalance});
        });

        _showSnackBar('Pago realizado correctamente.');
        Navigator.pop(context);
      } catch (e) {
        _showSnackBar('Error al realizar el pago: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                    // Encabezado con ícono y título
                    Row(
                      children: [
                        Icon(Icons.payment, color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Realizar Pago',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Campo de monto a pagar
                    _buildTextField(
                      label: 'Monto a Pagar',
                      controller: _paymentController,
                      icon: Icons.attach_money,
                    ),
                    SizedBox(height: 30),
                    // Botón de pago
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _makePayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Realizar Pago',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    // Botón para regresar al menú anterior
                    _buildBackButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            double.tryParse(value) == null ||
            double.parse(value) <= 0) {
          return 'Ingresa un monto válido';
        }
        return null;
      },
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 5),
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
      ),
    );
  }
}
