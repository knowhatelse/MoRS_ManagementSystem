class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://192.168.0.7:5000/api';
  static const String authTokenUrl = 'http://192.168.0.7:5000/connect/token';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration requestTimeout = Duration(seconds: 5);

  // Authentication
  static const String clientId = 'mors_client';
  static const String clientSecret = 'secret';
  static const String grantType = 'password';
  static const String scope = 'api openid profile';

  // UI Configuration
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration notificationPollingInterval = Duration(seconds: 30);

  // Business Hours Configuration
  static const int businessHoursStart = 8; // 8 AM
  static const int businessHoursEnd = 18; // 6 PM
  static const int timeSlotDurationHours = 1;

  // PayPal Configuration
  static const String paypalClientId =
      'AU_BLC0sXqU-rj-hGwkSHcQS3T00wf9JzJMXmLMpikOlrnmquUvo1M0G7pEBYYVmo3f8-ylIcb0b_HDB';
  static const String paypalClientSecret =
      'EFIi2vMwSDjU11rIAht7A6AtEAr4BzBKE5RZL8u3APtoeoBmtNMVyiOIQQvySJXgXzwerRHAg_PLw3n3';
  static const String paypalSandboxUrl = 'https://api.sandbox.paypal.com';
  static const String paypalProductionUrl = 'https://api.paypal.com';
  static const String paypalSuccessUrl = 'https://mors-payment-success.com';
  static const String paypalCancelUrl = 'https://mors-payment-cancel.com';

  // Payment Status
  static const int paymentStatusCompleted = 1;
  static const int paymentStatusPending = 0;
  static const int paymentStatusFailed = 2;

  // Payment Methods
  static const int paymentMethodPayPal = 1;
  static const int paymentMethodCreditCard = 0;
}
