import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripeapp/bloc/pagar/pagar_bloc.dart';
import 'package:stripeapp/screens/screens.dart';
import 'package:stripeapp/services/stripe_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Inicializamos StripeService
    final stripeService = StripeService();
    stripeService.init();

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => PagarBloc())],
      child: MaterialApp(
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
      ),
    );
  }
}
