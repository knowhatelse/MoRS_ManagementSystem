import '../config/app_config.dart';

class PayPalConfig {
  static String get clientId => AppConfig.paypalClientId;
  static String get clientSecret => AppConfig.paypalClientSecret;

  static String get sandboxBaseUrl => AppConfig.paypalSandboxUrl;
  static String get productionBaseUrl => AppConfig.paypalProductionUrl;

  static String get baseUrl => sandboxBaseUrl;

  static String get successUrl => AppConfig.paypalSuccessUrl;
  static String get cancelUrl => AppConfig.paypalCancelUrl;

  static int get statusCompleted => AppConfig.paymentStatusCompleted;
  static int get statusPending => AppConfig.paymentStatusPending;
  static int get statusFailed => AppConfig.paymentStatusFailed;

  static int get paymentMethodPayPal => AppConfig.paymentMethodPayPal;
  static int get paymentMethodCreditCard => AppConfig.paymentMethodCreditCard;
  static const int paymentMethodBankTransfer = 2;
  static const int paymentMethodCash = 3;
}
