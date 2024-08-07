import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripeapp/bloc/pagar/pagar_bloc.dart';
import 'package:stripeapp/widgets/total_pay_button.dart';

class TarjetaScreen extends StatelessWidget {
  const TarjetaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pagarBloc = BlocProvider.of<PagarBloc>(context);

    final tarjeta = pagarBloc.state.tarjeta;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Pagar'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              pagarBloc.add(OnDesactivarTarjeta());
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            //Container(),
            Hero(
              tag: tarjeta!.cardNumber,
              child: CreditCardWidget(
                isHolderNameVisible: true,
                cardNumber: tarjeta.cardNumberHidden,
                expiryDate: tarjeta.expiracyDate,
                cardHolderName: tarjeta.cardHolderName,
                cvvCode: tarjeta.cvv,
                showBackView: false,
                onCreditCardWidgetChange: (creditCardBrand) {},
              ),
            ),
            const Positioned(bottom: 0, child: TotalPayButton())
          ],
        ));
  }
}
