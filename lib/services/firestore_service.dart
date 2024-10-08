import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_balance.dart';
import '../models/loan.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener el saldo ficticio del usuario
  Future<UserBalance?> getUserBalance() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    DocumentSnapshot snapshot = await _firestore.collection('user_balances').doc(user.uid).get();

    if (snapshot.exists) {
      return UserBalance.fromMap(snapshot.data() as Map<String, dynamic>);
    } else {
      // Si no existe, crear uno con un saldo inicial
      UserBalance initialBalance = UserBalance(balance: 1000.0); // Saldo inicial ficticio
      await _firestore.collection('user_balances').doc(user.uid).set(initialBalance.toMap());
      return initialBalance;
    }
  }

  // Actualizar el saldo ficticio del usuario
  Future<void> updateUserBalance(double newBalance) async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    await _firestore.collection('user_balances').doc(user.uid).update({
      'balance': newBalance,
    });
  }

  // Solicitar un préstamo
  Future<void> requestLoan(Loan loan) async {
    await _firestore.collection('loans').add(loan.toMap());

    // Actualizar el saldo ficticio
    DocumentSnapshot balanceSnapshot = await _firestore.collection('user_balances').doc(loan.userId).get();
    if (balanceSnapshot.exists) {
      double currentBalance = balanceSnapshot['balance'];
      double newBalance = currentBalance + loan.amount;
      await updateUserBalance(newBalance);
    } else {
      // Crear un nuevo documento de balance si no existe
      await _firestore.collection('user_balances').doc(loan.userId).set({
        'balance': loan.amount,
      });
    }
  }

  // Realizar un pago
  Future<void> makePayment(String loanId, double paymentAmount) async {
    DocumentReference loanRef = _firestore.collection('loans').doc(loanId);

    // Obtener el préstamo actual
    DocumentSnapshot loanSnapshot = await loanRef.get();
    if (!loanSnapshot.exists) throw Exception('Préstamo no encontrado');

    double currentBalance = loanSnapshot['balance'];
    double newBalance = currentBalance - paymentAmount;
    if (newBalance < 0) newBalance = 0;

    // Actualizar el balance del préstamo
    await loanRef.update({
      'balance': newBalance,
    });

    // Añadir el pago al subcolección 'payments'
    await loanRef.collection('payments').add({
      'amount': paymentAmount,
      'date': Timestamp.now(),
    });

    // Actualizar el saldo ficticio del usuario
    String userId = loanSnapshot['userId'];
    DocumentSnapshot balanceSnapshot = await _firestore.collection('user_balances').doc(userId).get();
    if (balanceSnapshot.exists) {
      double currentBalance = balanceSnapshot['balance'];
      double updatedBalance = currentBalance - paymentAmount;
      if (updatedBalance < 0) updatedBalance = 0;
      await _firestore.collection('user_balances').doc(userId).update({
        'balance': updatedBalance,
      });
    }
  }

  // Obtener el historial de pagos de un préstamo
  Stream<QuerySnapshot> getPaymentHistory(String loanId) {
    return _firestore
        .collection('loans')
        .doc(loanId)
        .collection('payments')
        .orderBy('date', descending: true)
        .snapshots();
  }
}
