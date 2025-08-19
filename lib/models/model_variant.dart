class ModelVariant {
  int? variantId;
  String? variantName;
  String? variantNameAr;
  int? modelId;
  String? status;
  String? createdAt;
  bool? isDeleted;

  ModelVariant({
    this.variantId,
    this.variantName,
    this.variantNameAr,
    this.modelId,
    this.status,
    this.createdAt,
    this.isDeleted,
  });

  factory ModelVariant.fromMap(Map<String, dynamic> map) {
    return ModelVariant(
      variantId: map['VariantId']?.toInt(),
      variantName: map['VariantName'],
      variantNameAr: map['VariantNameAr'],
      modelId: map['ModelId']?.toInt(),
      status: map['Status'],
      createdAt: map['CreatedAt'],
      isDeleted: map['IsDeleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'VariantId': variantId,
      'VariantName': variantName,
      'VariantNameAr': variantNameAr,
      'ModelId': modelId,
      'Status': status,
      'CreatedAt': createdAt,
      'IsDeleted': isDeleted,
    };
  }
}