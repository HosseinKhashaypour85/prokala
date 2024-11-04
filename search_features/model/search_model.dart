class SearchModel {
  SearchModel({
    this.status,
    this.products,
  });

  SearchModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }

  int? status;
  List<Products>? products;
}

class Products {
  Products({
    this.productId,
    this.productImage,
    this.productTitle,
    this.productPrice,
  });

  Products.fromJson(dynamic json) {
    productId = json['product_id'] ?? 'محصول نامجود هست';
    productImage = json['product_image'] ?? 'محصول نامجود هست';
    productTitle = json['product_title'] ?? 'محصول نامجود هست';
    productPrice = json['product_price'] ?? 'محصول نامجود هست';
  }

  int? productId;
  String? productImage;
  String? productTitle;
  String? productPrice;
}
