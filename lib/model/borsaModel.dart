class BorsaModel {
  BorsaModel(this.id, this.isSell,this.formatTarih, this.adet, this.fiyat);

  final int? id;
  final bool isSell;
  final String formatTarih;
  final double adet;
  final double fiyat;

  factory BorsaModel.fromJson(Map<String, dynamic> json) {
    // Use the null-aware operators to provide a default value or allow null
    return BorsaModel(
      json['id'] as int?,
      json['sell'] as bool? ?? false,
      json['date'] as String? ?? '',
      (json['lot'] as num?)?.toDouble() ?? 0.0,
      (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

}