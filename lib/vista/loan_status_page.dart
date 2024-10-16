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

class _LoanStatusPageState extends State<LoanStatusPage>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _paymentController = TextEditingController();
  double _paymentAmount = 0.0;
  double _userBalance = 0.0;
  Loan? _selectedLoan; // Préstamo seleccionado
  List<Loan> _loans = []; // Lista de préstamos del usuario
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _fetchUserBalance();
    _fetchLoans(); // Cargar préstamos activos del usuario
  }

  @override
  void dispose() {
    _controller.dispose();
    _paymentController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserBalance() async {
    UserBalance? userBalance = await _firestoreService.getUserBalance();
    setState(() {
      _userBalance = userBalance?.balance ?? 0.0;
    });
  }

  Future<void> _fetchLoans() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('loans')
        .where('userId', isEqualTo: user.uid)
        .get();

    setState(() {
      _loans = snapshot.docs.map((doc) => Loan.fromDocument(doc)).toList();
      if (_loans.isNotEmpty) {
        _selectedLoan = _loans.first;
      }
    });
  }

  Future<void> _makePayment() async {
    if (_selectedLoan == null) return;

    _paymentAmount = double.tryParse(_paymentController.text) ?? 0.0;

    if (_paymentAmount <= 0) {
      _showMessage('Ingresa un monto válido para el pago.');
      return;
    }

    if (_paymentAmount > _userBalance) {
      _showMessage('Saldo insuficiente.');
      return;
    }

    double newBalance = _selectedLoan!.balance - _paymentAmount;
    double newUserBalance = _userBalance - _paymentAmount;

    if (newBalance < 0) newBalance = 0;

    try {
      await FirebaseFirestore.instance
          .collection('loans')
          .doc(_selectedLoan!.id)
          .update({'balance': newBalance});

      await FirebaseFirestore.instance
          .collection('loans')
          .doc(_selectedLoan!.id)
          .collection('payments')
          .add({
        'amount': _paymentAmount,
        'date': Timestamp.now(),
      });

      await _firestoreService.updateUserBalance(newUserBalance);

      _showMessage('Pago realizado con éxito.');

      setState(() {
        _userBalance = newUserBalance;
        _selectedLoan!.balance = newBalance;
        _paymentController.clear();
      });
    } catch (e) {
      print('Error al realizar el pago: $e');
      _showMessage('Error al realizar el pago. Inténtalo de nuevo.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 94, 35),
      body: SafeArea(
        child: FadeTransition(
          opacity: _animation,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    SizedBox(height: 80),
                    _buildLoanDropdown(), // Selector de préstamo
                    _buildLoanInfoCard('Saldo Ficticio', _userBalance,
                        Icons.account_balance_wallet),
                    _selectedLoan != null
                        ? _buildLoanInfoCard('Balance Pendiente',
                            _selectedLoan!.balance, Icons.account_balance)
                        : Container(),
                    SizedBox(height: 20),
                    _buildPaymentField(),
                    SizedBox(height: 10),
                    _selectedLoan != null
                        ? _buildPaymentHistory(_selectedLoan!.id)
                        : Container(),
                  ],
                ),
              ),
              _buildBackButton(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _makePayment,
        backgroundColor: Colors.green,
        icon: Icon(Icons.payment),
        label: Text('Realizar Pago'),
      ),
    );
  }

  Widget _buildLoanDropdown() {
    return DropdownButtonFormField<Loan>(
      value: _selectedLoan,
      items: _loans.map((loan) {
        return DropdownMenuItem(
          value: loan,
          child: Text(
            'Préstamo: \$${loan.amount.toStringAsFixed(2)} - Balance: \$${loan.balance.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: (Loan? newLoan) {
        setState(() {
          _selectedLoan = newLoan;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        labelText: 'Selecciona un Préstamo',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.grey.shade800,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 20,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/userMenu'),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildLoanInfoCard(String label, num value, IconData icon,
      {bool isPercentage = false, bool isMonths = false}) {
    String displayValue = isPercentage
        ? '${value.toStringAsFixed(2)}%'
        : isMonths
            ? '$value meses'
            : '\$${value.toStringAsFixed(2)}';

    return Card(
      color: Colors.grey.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 30),
        title: Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
        trailing: Text(displayValue,
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _buildPaymentField() {
    return TextField(
      controller: _paymentController,
      decoration: InputDecoration(
        labelText: 'Monto del Pago',
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildPaymentHistory(String loanId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('loans')
          .doc(loanId)
          .collection('payments')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No hay pagos registrados.',
              style: TextStyle(color: Colors.white));
        }

        final payments = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: payments.length,
          itemBuilder: (context, index) {
            var payment = payments[index];
            double amount = payment['amount'];
            DateTime date = (payment['date'] as Timestamp).toDate();

            return ListTile(
              leading: Icon(Icons.payment, color: Colors.green),
              title: Text('Pago de \$${amount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'Fecha: ${date.day}/${date.month}/${date.year}',
                style: TextStyle(color: Colors.white70),
              ),
            );
          },
        );
      },
    );
  }
}
