import 'package:dio/dio.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripeapp/helpers/helpers.dart';
import 'package:stripeapp/models/payment_intent_response.dart';
import 'package:stripeapp/models/stripe_custom_response.dart';

class StripeService {
  //Singleton

  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();
  factory StripeService() => _instance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String _secretKey =
      'sk_test_51HSMLjBbBVGNMYmJ0jNiKNmbnKNJl1IwsBHX8OCvdy3bsMxYS8UNpFBlcwwVLxctEuoSimMDCwJB0pulXPToBiq600tcAJI2hS';
  String _apiKey =
      'pk_test_51HSMLjBbBVGNMYmJ2xJH31EepNGbXxJYj6LTOg1wI730cOIVjBH59JiJk3zZB1mZKOPE1OKGLzjg8L2CBulYH8LK002U1BFT9a';

  final headerOptions = Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: {'Authorization': 'Bearer ${StripeService._secretKey}'});

  void init() {
    StripePayment.setOptions(
      StripeOptions(
          publishableKey: _apiKey, androidPayMode: 'test', merchantId: "Test"),
    );
  }

  Future<StripeCustomResponse> pagarConTarjetaExistente(
      String amount, String currency, CreditCard card) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));

      final resp = await _realizarPago(amount, currency, paymentMethod);

      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<StripeCustomResponse> pagarConNuevaTarjeta(
      String amount, String currency) async {
    String _amount = amount;
    String _currency = currency;

    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());

      final resp = await _realizarPago(amount, currency, paymentMethod);

      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future pagarApplePayGooglePay(String amount, String currency) async {
    try {
      final newAmount = double.parse(amount) / 100;
      final token = await StripePayment.paymentRequestWithNativePay(
          androidPayOptions: AndroidPayPaymentRequest(
              currencyCode: currency, totalPrice: amount),
          applePayOptions: ApplePayPaymentOptions(
              countryCode: 'US',
              currencyCode: currency,
              items: [
                ApplePayItem(
                  label: 'Super producto 1',
                  amount: '$newAmount',
                )
              ]));

      final paymentMethod =
          await StripePayment.createPaymentMethod(PaymentMethodRequest(
              card: CreditCard(
        token: token.tokenId,
      )));

      final resp = await _realizarPago(amount, currency, paymentMethod);

      await StripePayment.completeNativePayRequest();

      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future _createPaymentIntent(String amount, String currency) async {
    try {
      final dio = Dio();
      final data = {'amount': amount, 'currency': currency};

      final resp =
          await dio.post(_paymentApiUrl, data: data, options: headerOptions);

      var respuesta = PaymentIntentResponse.fromJson(resp.data);

      return respuesta;
    } catch (e) {
      print('Error en intento: ${e.toString()}');
      return PaymentIntentResponse(status: '400');
    }
  }

  Future<StripeCustomResponse> _realizarPago(
      String amount, String currency, PaymentMethod paymentMethod) async {
    try {
      final paymentIntent = await _createPaymentIntent(amount, currency);

      final paymentResult = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent.clientSecret,
              paymentMethodId: paymentMethod.id));

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(
            ok: false, msg: 'Fallo: ${paymentResult.status}');
      }
    } catch (e) {
      print(e.toString());
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }
}
