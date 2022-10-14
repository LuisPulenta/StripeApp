import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripeapp/helpers/helpers.dart';
import 'package:stripeapp/models/stripe_custom_response.dart';

class StripeService {
  //Singleton

  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();
  factory StripeService() => _instance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  String _secretKey =
      'sk_test_51HSMLjBbBVGNMYmJ0jNiKNmbnKNJl1IwsBHX8OCvdy3bsMxYS8UNpFBlcwwVLxctEuoSimMDCwJB0pulXPToBiq600tcAJI2hS';
  String _apiKey =
      'pk_test_51HSMLjBbBVGNMYmJ2xJH31EepNGbXxJYj6LTOg1wI730cOIVjBH59JiJk3zZB1mZKOPE1OKGLzjg8L2CBulYH8LK002U1BFT9a';

  void init() {
    StripePayment.setOptions(
      StripeOptions(
          publishableKey: _apiKey, androidPayMode: 'test', merchantId: "Test"),
    );
  }

  Future pagarConTarjetaExistente(
      String amount, String currency, CreditCard card) async {}

  Future<StripeCustomResponse> pagarConNuevaTarjeta(
      String amount, String currency) async {
    String _amount = amount;
    String _currency = currency;

    var a = 1;

    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      //Crear el intent

      return StripeCustomResponse(ok: true);
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future pagarApplePayGooglePay(String amount, String currency) async {}

  Future _createPaymentIntent(String amount, String currency) async {}

  Future _realizarPago(
      String amount, String currency, PaymentMethod paymentMethod) async {}
}
