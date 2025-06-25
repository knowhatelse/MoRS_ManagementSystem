class PayPalConfig {
  static const String clientId =
      'AU_BLC0sXqU-rj-hGwkSHcQS3T00wf9JzJMXmLMpikOlrnmquUvo1M0G7pEBYYVmo3f8-ylIcb0b_HDB';
  static const String clientSecret =
      'EFIi2vMwSDjU11rIAht7A6AtEAr4BzBKE5RZL8u3APtoeoBmtNMVyiOIQQvySJXgXzwerRHAg_PLw3n3';

  static const String sandboxBaseUrl = 'https://api.sandbox.paypal.com';
  static const String productionBaseUrl = 'https://api.paypal.com';
 
  static const String baseUrl = sandboxBaseUrl;

  static const String successUrl = 'https://mors-payment-success.com';
  static const String cancelUrl = 'https://mors-payment-cancel.com';

  static const int statusCompleted = 1; 
  static const int statusPending = 0; 
  static const int statusFailed = 2; 

  static const int paymentMethodPayPal = 1;
  static const int paymentMethodCreditCard = 0;
  static const int paymentMethodBankTransfer = 2;
  static const int paymentMethodCash = 3;
}
