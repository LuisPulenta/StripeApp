import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripeapp/bloc/pagar/pagar_bloc.dart';

import 'package:stripeapp/data/tarjetas.dart';
import 'package:stripeapp/helpers/helpers.dart';
import 'package:stripeapp/screens/screens.dart';
import 'package:stripeapp/services/stripe_service.dart';
import 'package:stripeapp/widgets/total_pay_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final stripeService = StripeService();
    final pagarBloc = BlocProvider.of<PagarBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Pagar'),
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  mostrarLoading(context);

                  final amount = pagarBloc.state.montoPagarString;
                  final currency = pagarBloc.state.moneda;
                  final resp = await stripeService.pagarConNuevaTarjeta(
                      amount, currency);

                  Navigator.pop(context);

                  if (resp.ok) {
                    mostrarAlerta(context, 'Tarjeta Ok', 'Todo correcto');
                  } else {
                    mostrarAlerta(context, 'Algo salió mal', resp.msg);
                  }
                })
          ],
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned(
              width: size.width,
              height: size.height,
              top: 200,
              child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  physics: const BouncingScrollPhysics(),
                  itemCount: tarjetas.length,
                  itemBuilder: (_, i) {
                    final tarjeta = tarjetas[i];

                    return GestureDetector(
                      onTap: () {
                        pagarBloc.add(OnSeleccionarTarjeta(tarjeta));
                        Navigator.push(
                            context, navegarFadeIn(context, TarjetaScreen()));
                      },
                      child: Hero(
                        tag: tarjeta.cardNumber,
                        child: CreditCardWidget(
                          isHolderNameVisible: true,
                          cardNumber: tarjeta.cardNumberHidden,
                          expiryDate: tarjeta.expiracyDate,
                          cardHolderName: tarjeta.cardHolderName,
                          cvvCode: tarjeta.cvv,
                          showBackView: false,
                          onCreditCardWidgetChange: (CreditCardBrand) {},
                        ),
                      ),
                    );
                  }),
            ),
            Positioned(bottom: 0, child: TotalPayButton())
          ],
        ));
  }
}
