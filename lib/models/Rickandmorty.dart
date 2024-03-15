// POJO (Plain Old Java Object)
class Rickandmorty {
  final String? name;
  final String? type;
  final String? gender;
  final String? origin;
  final String? image;

  Rickandmorty({
    required this.name,
    required this.type,
    required this.gender,
    required this.origin,
    required this.image,
  });

  factory Rickandmorty.fromJson(Map<String, dynamic> json) {
    return Rickandmorty(
      name: json['name'],
      type: json['type'],
      gender: json['gender'],
      origin: json['origin'],
      image: json['image'],
    );
  }
}