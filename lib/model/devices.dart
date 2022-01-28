class Device {
  final int? id;
  final String? patri;
  final String? sn;
  final String? name;
  final String? user;
  final String? setor;
  final String? brand;
  final String? model;
  final String? type;
  final String? status;
  final String? image;

  Device({this.id, this.patri, this.sn, this.name, this.user, this.setor, this.brand, this.model, this.type, this.status, this.image});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      patri: json['patri'],
      sn: json['sn'],
      name: json['name'],
      user: json['user'],
      setor: json['setor'],
      brand: json['brand'],
      model: json['model'],
      type: json['type'],
      status: json['status'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'patri': patri,
    'sn': sn,
    'name': name,
    'user': user,
    'setor': setor,
    'brand': brand,
    'model': model,
    'type': type,
    'status': status,
    'image': image,

  };
}