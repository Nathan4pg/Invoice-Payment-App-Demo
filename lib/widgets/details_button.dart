import 'package:flutter/material.dart';
import '../models/invoices_provider.dart';

class DetailsButton extends StatefulWidget {
  final Invoice invoice;

  const DetailsButton({super.key, required this.invoice});

  @override
  DetailsButtonState createState() => DetailsButtonState();
}

class DetailsButtonState extends State<DetailsButton> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        children: [
          const Text('Details'),
          if (isExpanded)
            Column(
              children: [
                Text('Paid Date: ${widget.invoice.paidDate}'),
                Text('Gross Amount: ${widget.invoice.grossAmount}'),
                Text('Invoiced Date: ${widget.invoice.invoicedDate}'),
                Text('Order Number: ${widget.invoice.orderNumber}'),
                Text('Delivery Date: ${widget.invoice.deliveryDate}'),
                Text('Sales Rep: ${widget.invoice.salesRepresentative}'),
                Text('Shipping Company: ${widget.invoice.shippingCompany}'),
                Text(
                    'Shipment Tracking ID: ${widget.invoice.shipmentTrackingId}'),
              ],
            ),
        ],
      ),
    );
  }
}
