// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  late String id;
  late String name;
  late String price;
  late String image;
  late String description;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.description =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
  });
}
