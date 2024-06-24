class QrInfo {
  String category;
  String qr_code_id;
  String UrlKey;
  String? price;
  String? image; // Image URL which can be null initially

  QrInfo({
    required this.category,
    required this.qr_code_id,
    required this.UrlKey,
    this.price,
  });
}
