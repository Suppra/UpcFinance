class UserBalance {
  double balance;

  UserBalance({required this.balance});

  // Convertir un objeto UserBalance a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
    };
  }

  // Crear un objeto UserBalance desde un mapa de Firestore
  factory UserBalance.fromMap(Map<String, dynamic> map) {
    return UserBalance(
      balance: map['balance'],
    );
  }
}
