class Promo {
  final String imageName;
  final String imageId;

  Promo({
    required this.imageName,
    required this.imageId,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      imageName: json['imageName'],
      imageId: json['imageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageName': imageName,
      'imageId': imageId,
    };
  }
}