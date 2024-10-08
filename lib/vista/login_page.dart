import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  
  String email = '';
  String password = '';
  bool isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navegar al menú de usuario
      Navigator.of(context).pushNamedAndRemoveUntil('/userMenu', (route) => false);
    } on FirebaseAuthException catch (e) {
      String message = 'Error al iniciar sesión';
      if (e.code == 'user-not-found') {
        message = 'No se encontró ningún usuario con ese correo.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión. Inténtalo de nuevo.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/finances_background.png'), // Cambia por la ruta correcta de la imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Fondo de color semitransparente para mejorar la legibilidad
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // Contenido principal
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo de la app
                            Image.asset(
                              'assets/images/fincalc_logo.png', // Cambia por la ruta correcta del logo
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 40),
                            // Campo de correo electrónico
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Correo Electrónico',
                                labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                filled: true,
                                fillColor: const Color.fromARGB(255, 32, 189, 79).withOpacity(0.8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) {
                                email = value!.trim();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu correo electrónico';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Ingresa un correo electrónico válido';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 36),
                            // Campo de contraseña
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                labelStyle: TextStyle(color: const Color.fromARGB(255, 252, 253, 253)),
                                filled: true,
                                fillColor: const Color.fromARGB(255, 37, 184, 44).withOpacity(0.8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              obscureText: true,
                              onSaved: (value) {
                                password = value!;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                if (value.length < 6) {
                                  return 'La contraseña debe tener al menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            // Botón de inicio de sesión
                            ElevatedButton(
                                     onPressed: _login,
                                     style: ElevatedButton.styleFrom(
                                     backgroundColor: Colors.green, // Color del botón
                                     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                                     shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(30),
                                         ),
                                            ),
                                  child: Text(
                                   'Iniciar Sesión',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                   ),
                                     ),

                            SizedBox(height: 20),
                            // Enlace para registrarse
                            TextButton(
                              onPressed: _navigateToRegister,
                              child: Text(
                                '¿No tienes una cuenta? Regístrate',
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
