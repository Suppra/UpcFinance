import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'vista/user__menu.dart';
import 'vista/register_page.dart';
import 'vista/simple_interest_amount.dart';
import 'vista/simple_interest_rate.dart';
import 'vista/simple_interest_time.dart';
import 'vista/compound_interest_amount.dart';
import 'vista/compound_interest_rate.dart';
import 'vista/compound_interest_time.dart';
import 'vista/arithmetic_gradient_value.dart';
import 'vista/arithmetic_gradient_series.dart';
import 'vista/geometric_gradient_value.dart';
import 'vista/geometric_gradient_series.dart';
import 'vista/amortization_german.dart';
import 'vista/amortization_french.dart';
import 'vista/amortization_american.dart';
import 'vista/loan_request_page.dart';
import 'vista/loan_status_page.dart';
import 'vista/login_page.dart';
import 'vista/tir_screen.dart';
import 'vista/uvr_screen.dart';
import 'vista/vpn_screen.dart';
import 'vista/bonos_screen.dart';
import 'vista/inflacion_screen.dart';
import 'vista/forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPC Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
      routes: {
        '/userMenu': (context) => UserMenu(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/simpleInterestAmount': (context) => SimpleInterestAmount(),
        '/simpleInterestRate': (context) => SimpleInterestRate(),
        '/simpleInterestTime': (context) => SimpleInterestTime(),
        '/compoundInterestAmount': (context) => CompoundInterestAmount(),
        '/compoundInterestRate': (context) => CompoundInterestRate(),
        '/compoundInterestTime': (context) => CompoundInterestTime(),
        '/arithmeticGradientValue': (context) => ArithmeticGradientValue(),
        '/arithmeticGradientSeries': (context) => ArithmeticGradientSeries(),
        '/geometricGradientValue': (context) => GeometricGradientValue(),
        '/geometricGradientSeries': (context) => GeometricGradientSeries(),
        '/amortizationGerman': (context) => AmortizationGerman(),
        '/amortizationFrench': (context) => AmortizationFrench(),
        '/amortizationAmerican': (context) => AmortizationAmerican(),
        '/loanRequest': (context) => LoanRequestPage(),
        '/loanStatus': (context) => LoanStatusPage(),
        '/tir': (context) => TIRScreen(),
        '/uvr': (context) => UVRScreen(),
        '/vpn': (context) => VPNScreen(),
        '/bonos': (context) => BonosScreen(),
        '/inflacion': (context) => InflacionScreen(),
      },
    );
  }
}
