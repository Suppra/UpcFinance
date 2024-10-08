import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el correo del usuario actual
    final String email = FirebaseAuth.instance.currentUser?.email ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menú de Usuario - UPC Finance',
          style: TextStyle(
            color: Colors.white, // Cambia este color al que desees
          ),
        ),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  image: AssetImage('assets/images/fincalc_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'UPC FINANCE',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Interés Simple
            ExpansionTile(
              leading: Icon(Icons.attach_money, color: Colors.green),
              title:
                  Text('Interés Simple', style: TextStyle(color: Colors.black)),
              children: [
                ListTile(
                  title: Text('Monto Futuro',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/simpleInterestAmount');
                  },
                ),
                ListTile(
                  title: Text('Tasa de Interés',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/simpleInterestRate');
                  },
                ),
                ListTile(
                  title:
                      Text('Tiempo', style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/simpleInterestTime');
                  },
                ),
              ],
            ),
            // Interés Compuesto
            ExpansionTile(
              leading: Icon(Icons.calculate, color: Colors.green),
              title: Text('Interés Compuesto',
                  style: TextStyle(color: Colors.black)),
              children: [
                ListTile(
                  title: Text('Monto Futuro',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/compoundInterestAmount');
                  },
                ),
                ListTile(
                  title: Text('Tasa de Interés',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/compoundInterestRate');
                  },
                ),
                ListTile(
                  title:
                      Text('Tiempo', style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/compoundInterestTime');
                  },
                ),
              ],
            ),
            // Gradiente Aritmético
            ExpansionTile(
              leading: Icon(Icons.trending_up, color: Colors.green),
              title: Text('Gradiente Aritmético',
                  style: TextStyle(color: Colors.black)),
              children: [
                ListTile(
                  title: Text('Valor Presente/Futuro',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/arithmeticGradientValue');
                  },
                ),
                ListTile(
                  title: Text('Valor de la Serie',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/arithmeticGradientSeries');
                  },
                ),
              ],
            ),
            // Gradiente Geométrico
            ExpansionTile(
              leading: Icon(Icons.trending_down, color: Colors.green),
              title: Text('Gradiente Geométrico',
                  style: TextStyle(color: Colors.black)),
              children: [
                ListTile(
                  title: Text('Valor Presente/Futuro',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/geometricGradientValue');
                  },
                ),
                ListTile(
                  title: Text('Valor de la Serie',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/geometricGradientSeries');
                  },
                ),
              ],
            ),
            // Amortización
            ExpansionTile(
              leading: Icon(Icons.table_chart, color: Colors.green),
              title:
                  Text('Amortización', style: TextStyle(color: Colors.black)),
              children: [
                ListTile(
                  title: Text('Método Alemán',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/amortizationGerman');
                  },
                ),
                ListTile(
                  title: Text('Método Francés',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/amortizationFrench');
                  },
                ),
                ListTile(
                  title: Text('Método Americano',
                      style: TextStyle(color: Colors.black87)),
                  onTap: () {
                    Navigator.pushNamed(context, '/amortizationAmerican');
                  },
                ),
              ],
            ),
            Divider(),
            // Solicitar Préstamo
            ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.green),
              title: Text('Solicitar Préstamo',
                  style: TextStyle(color: Colors.black87)),
              onTap: () {
                Navigator.pushNamed(context, '/loanRequest');
              },
            ),
            // Ver Estado del Préstamo
            ListTile(
              leading: Icon(Icons.account_balance_wallet, color: Colors.green),
              title: Text('Ver Estado del Préstamo',
                  style: TextStyle(color: Colors.black87)),
              onTap: () {
                Navigator.pushNamed(context, '/loanStatus');
              },
            ),
            // Cerrar Sesión
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text('Cerrar Sesión',
                  style: TextStyle(color: Colors.black87)),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Error al cerrar sesión. Inténtalo de nuevo.'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/finances_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                // Usar FutureBuilder para obtener el monto del préstamo
                _buildDashboard(email),
                SizedBox(height: 20),
                Text(
                  'Bienvenido a UPC Finance',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'UPC Finance es una aplicación diseñada para facilitar cálculos financieros. Ofrece herramientas avanzadas para calcular intereses simples y compuestos, gradientes aritméticos y geométricos, y opciones para amortización de préstamos con los métodos alemán, francés y americano.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(String email) {
    // Obtener el UID del usuario actual
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('loans')
          .where('userId', isEqualTo: userId)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un cargador mientras se obtiene el monto
        }

        if (snapshot.hasError) {
          return Text('Error al cargar el monto');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(
              'Monto no disponible'); // Manejar caso cuando no hay documentos
        }

        // Obtener el monto desde Firestore (asumiendo que quieres el primero)
        final double amount =
            snapshot.data!.docs.first['amount']?.toDouble() ?? 0.0;

        return Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: const Color.fromARGB(255, 32, 151, 72).withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/default_user.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Correo: $email',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 252, 252, 252)),
                ),
                SizedBox(height: 10),
                Text(
                  'Saldo Disponible: \$${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
