class ProductModel {
  Product? product;
  int? totalPrice;
  List<Gallery>? gallery;
  dynamic percent;
  bool? fav;
  String? brand;
  bool? checkCart;
  List<UserComments>? userComments;

  ProductModel.fromJson(dynamic json) {
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    totalPrice = json['total_price'] ?? 0;
    percent = json['percent'] ?? 0;
    brand = json['brand'] ?? '';
    checkCart = json['check_cart'];
    fav = json['fav'];

    if (json['gallerys'] != null) {
      gallery = [];
      json['gallerys'].forEach(
        (value) {
          gallery?.add(Gallery.fromJson(value));
        },
      );
      if(json['comments'] !=null){
        userComments = [];
        json['comments'].forEach((value){
          userComments?.add(UserComments.fromJson(value));
        });
      }
    }
  }
}

class Gallery {
  int? id;
  String? path;

  Gallery(this.id, this.path);

  Gallery.fromJson(dynamic json) {
    id = json['id'];
    path = json['path'];
  }
}

class Product {
  int? id;
  String? title;
  String? enName;
  String? defaultPrice;
  String? deliverPrice;
  String? image;
  String? productBody;

  Product(
    this.id,
    this.title,
    this.enName,
    this.defaultPrice,
    this.deliverPrice,
    this.image,
    this.productBody,
  );

  Product.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    enName = json["en_name"];
    defaultPrice = json["default_price"] ?? 'ناله';
    deliverPrice = json["deliver_price"];
    image = json["image"];
    productBody = json["product_body"].toString().replaceAll('&zwnj;', '');
  }
}

class UserComments {
  int? commentId;
  int? userId;
  String? fullName;
  String? comment;
  String? date;

  UserComments(
    this.commentId,
    this.userId,
    this.fullName,
    this.comment,
    this.date,
  );
  UserComments.fromJson(dynamic json){
    commentId = json['comment_id'];
    userId = json['user_id'];
    fullName = json['fullname'];
    comment = json['comment'];
    date = json['date'];
  }
}
