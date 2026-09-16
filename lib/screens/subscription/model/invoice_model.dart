class InvoiceResponse {
  bool status;
  String invoiceLink;

  InvoiceResponse({
    this.status = false,
    this.invoiceLink = "",
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      status: json['status'] is bool ? json['status'] : false,
      invoiceLink: json['invoice_url'] is String ? json['invoice_url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'invoice_url': invoiceLink,
    };
  }
}