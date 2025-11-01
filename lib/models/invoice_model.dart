
class ProductItem {
  final String invoiceNumber;
  final String productName;
  final String description;
  final double quantity;
  final DateTime invoiceDate;
  final String unit;
  final double price;
  final double offerPrice;
  final String name;
  final String mobilenumber;
  final String address;
  final String hsn; 
  final String imagelogo;
  final double wastage;
  final bool isGoldItem;

  ProductItem({
    required this.invoiceNumber,
    required this.productName,
    required this.description,
    required this.quantity,
    required this.invoiceDate,
    required this.unit,
    required this.price,
    required this.offerPrice,
    required this.name,
    required this.mobilenumber,
    required this.address,
    required this.hsn,
    required this.imagelogo,
    this.wastage = 0.0,
    this.isGoldItem = false,
  });

  factory ProductItem.fromMap(Map<String, dynamic> map) {
    return ProductItem(
      invoiceNumber: map['invoiceNumber'] ?? '',
      productName: map['productName'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      invoiceDate: DateTime.parse(map['invoiceDate']),
      unit: map['unit'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      offerPrice: map['offerPrice']?.toDouble() ?? 0.0,
      name: map['name'] ?? '',
      mobilenumber: map['mobilenumber'] ?? '',
      address: map['address'] ?? '',
      hsn: map['hsn'] ?? '',
      imagelogo: map['imagelogo'] ?? '',
      wastage: map['wastage']?.toDouble() ?? 0.0,
      isGoldItem: map['isGoldItem'] ?? false,
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'invoiceNumber': invoiceNumber,
      'productName': productName,
      'description': description,
      'quantity': quantity,
      'invoiceDate': invoiceDate.toIso8601String(),
      'unit': unit,
      'price': price,
      'offerPrice': offerPrice,
      'name': name,
      'mobilenumber': mobilenumber,
      'address': address,
      'hsn': hsn,
      'imagelogo': imagelogo,
      'wastage': wastage,
      'isGoldItem': isGoldItem,
    };
  }
}

class Invoice {
  final String id;
  final List<ProductItem> products;
  final DateTime createdAt;
  final String userId;
  final bool isPaid; // Added payment status field
  final DateTime? paidDate; // Added paid date field
  final String? paymentMethod; // Added payment method field

  Invoice({
    required this.id,
    required this.products,
    required this.createdAt,
    required this.userId,
    this.isPaid = false, // Default to unpaid
    this.paidDate,
    this.paymentMethod,
  });

  // Calculate total amount for the invoice
  double get totalAmount {
    return products.fold(0.0, (sum, product) => sum + (product.offerPrice * product.quantity));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((product) => product.tojson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'isPaid': isPaid,
      'paidDate': paidDate?.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      products: (json['products'] as List)
          .map((item) => ProductItem.fromMap(item))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      isPaid: json['isPaid'] ?? false,
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
      paymentMethod: json['paymentMethod'],
    );
  }

  // Helper method to mark invoice as paid
  Invoice markAsPaid({required String method}) {
    return Invoice(
      id: id,
      products: products,
      createdAt: createdAt,
      userId: userId,
      isPaid: true,
      paidDate: DateTime.now(),
      paymentMethod: method,
    );
  }
}
