import 'package:flutter/material.dart';
import 'package:stripeapp/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stripe App',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'pago_completo': (_) => const PagoCompletoScreen(),
      },
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xff284879),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xff284879)),
        scaffoldBackgroundColor: const Color(0xff21232A),
      ),
    );
  }
}
