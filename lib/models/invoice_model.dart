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
        dueDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json['dueDate'] as String)),
        paidDate: json['paidDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                int.parse(json['paidDate'] as String))
            : null,
        grossAmount: json['grossAmount'] as String,
        invoicedDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json['invoicedDate'] as String)),
        orderNumber: json['orderNumber'] as String,
        deliveryDate: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json['deliveryDate'] as String)),
        salesRepresentative: json['salesRepresentative'] as String,
        shippingCompany: json['shippingCompany'] as String,
        shipmentTrackingId: json['shipmentTrackingId'] as String,
      );
    } catch (e) {
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'paid': paid,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'paidDate': paidDate?.millisecondsSinceEpoch,
      'grossAmount': grossAmount,
      'invoicedDate': invoicedDate.millisecondsSinceEpoch,
      'orderNumber': orderNumber,
      'deliveryDate': deliveryDate.millisecondsSinceEpoch,
      'salesRepresentative': salesRepresentative,
      'shippingCompany': shippingCompany,
      'shipmentTrackingId': shipmentTrackingId,
    };
  }
}
