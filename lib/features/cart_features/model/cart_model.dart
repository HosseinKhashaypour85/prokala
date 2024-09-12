class CartModel {
  int? cartTotal;
  int? cartCount;
  List<Cart>?cart;
  CartModel.fromJson(dynamic json){
    if(json['cart'] !=null){
      cart= [];
      json['cart'].forEach((value){
        cart?.add(Cart.fromJson(value));
      });
    }
    cartTotal = json['cart_total'];
    cartCount = json['cart_count'];
  }

  CartModel({this.cartTotal, this.cartCount, this.cart});
}


class Cart {
  int? cartId;
  int? productId;
  String? productTitle;
  String? productImage;
  String? count;
  int? productPrice;
  int? deliveryPrice;

  Cart(
    this.cartId,
    this.productId,
    this.productTitle,
    this.productImage,
    this.count,
    this.productPrice,
    this.deliveryPrice,
  );
  Cart.fromJson(dynamic json){
    cartId = json['cart_id'];
    productId = json['product_id'];
    productTitle = json['product_title'];
    productImage = json['product_image'];
    count = json['count'].toString();
    productPrice = json['product_price'];
    deliveryPrice = json['delivery_price'];
  }
}
