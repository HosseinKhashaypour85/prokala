class CategoryModel {
  int? status;
  List<Category>? category;

  CategoryModel(this.status, this.category);

  CategoryModel.fromJson(dynamic json){
    status = json['status'];

    if(json['category'] !=null){
      category = [];
      json['category'].forEach((value){
        category?.add(Category.fromJson(value));
      });
    }
  }
}

class Category {
  int? id;
  String? title;
  List<SubCategory>?subCategory;

  Category(this.id, this.title, this.subCategory);

  Category.fromJson(dynamic json){
    id = json['id'];
    title = json['title'];

    if(json['sub_category'] !=null){
      subCategory = [];
      json['sub_category'].forEach((value){
         subCategory?.add(SubCategory.fromJson(value));
      });
    }
  }
}

class SubCategory {
  int? id;
  String? title;
  String? parentId;
  String? image;

  SubCategory({
    required this.id,
    required this.title,
    required this.parentId,
    required this.image,
  });

  SubCategory.fromJson(dynamic json){
    id = json['id'];
    title = json['title'];
    parentId = json['parent_id'];
    image = json['image'];
  }
}
