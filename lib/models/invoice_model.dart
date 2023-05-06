class Invoice {
  final String id;
  final String amount;
  final bool paid;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String grossAmount;
  final DateTime invoicedDate;
  final String orderNumber;
  final DateTime deliveryDate;
  final String salesRepresentative;
  final String shippingCompany;
  final String shipmentTrackingId;

  Invoice({
    required this.id,
    required this.amount,
    required this.paid,
    required this.dueDate,
    this.paidDate,
    required this.grossAmount,
    required this.invoicedDate,
    required this.orderNumber,
    required this.deliveryDate,
    required this.salesRepresentative,
    required this.shippingCompany,
    required this.shipmentTrackingId,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    try {
      return Invoice(
        id: json['id'] as String,
        amount: json['amount'] as String,
        paid: json['paid'] as bool,
        dueDate: DateTime.parse(json['dueDate'] as String),
        paidDate: json['paidDate'] != null
            ? DateTime.parse(json['paidDate'] as String)
            : null,
        grossAmount: json['grossAmount'] as String,
        invoicedDate: DateTime.parse(json['invoicedDate'] as String),
        orderNumber: json['orderNumber'] as String,
        deliveryDate: DateTime.parse(json['deliveryDate'] as String),
        salesRepresentative: json['salesRepresentative'] as String,
        shippingCompany: json['shippingCompany'] as String,
        shipmentTrackingId: json['shipmentTrackingId'] as String,
      );
    } catch (e) {
// Handle the exception here, for example, log the error or return a default object
      print('Error parsing Invoice JSON: $e');
      return Invoice(
        id: '',
        amount: '0',
        paid: false,
        dueDate: DateTime.now(),
        paidDate: null,
        grossAmount: '0',
        invoicedDate: DateTime.now(),
        orderNumber: '',
        deliveryDate: DateTime.now(),
        salesRepresentative: '',
        shippingCompany: '',
        shipmentTrackingId: '',
      );
    }
  }
}
