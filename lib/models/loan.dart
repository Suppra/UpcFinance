import 'package:cloud_firestore/cloud_firestore.dart';

class Loan {
  String id;
  String userId;
  double amount;
  int term;
  double interestRate;
  DateTime requestDate;
  double balance;
  String loanType; // Agregar el campo loanType

  Loan({
    required this.id,
    required this.userId,
    required this.amount,
    required this.term,
    required this.interestRate,
    required this.requestDate,
    required this.balance,
    required this.loanType, // Asegurarse de pasar loanType en el constructor
  });

  // Métodos de conversión a Firestore (si los tienes)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'term': term,
      'interestRate': interestRate,
      'requestDate': requestDate,
      'balance': balance,
      'loanType': loanType, // Asegúrate de incluir loanType en el mapeo
    };
  }

  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      amount: map['amount'] ?? 0.0,
      term: map['term'] ?? 0,
      interestRate: map['interestRate'] ?? 0.0,
      requestDate: (map['requestDate'] as Timestamp).toDate(),
      balance: map['balance'] ?? 0.0,
      loanType: map['loanType'] ?? '', // Asegúrate de mapear loanType también
    );
  }

  // Método de fábrica para crear una instancia de Loan desde un documento de Firestore
  factory Loan.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Obtener los datos del documento
    return Loan(
      id: doc.id, // ID del documento
      userId: data['userId'] ?? '',
      amount: data['amount'] ?? 0.0,
      term: data['term'] ?? 0,
      interestRate: data['interestRate'] ?? 0.0,
      requestDate: (data['requestDate'] as Timestamp).toDate(),
      balance: data['balance'] ?? 0.0,
      loanType: data['loanType'] ?? '',
    );
  }
}
