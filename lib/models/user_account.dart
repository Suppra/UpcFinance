class UserAccount {
  String userId;
  double balance;

  UserAccount({
    required this.userId,
    required this.balance,
  });

  // Convertir un objeto UserAccount a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
    };
  }

  // Crear un objeto UserAccount desde un mapa de Firestore
  factory UserAccount.fromMap(String userId, Map<String, dynamic> map) {
    return UserAccount(
      userId: userId,
      balance: map['balance'] ?? 0.0,
    );
  }
}
