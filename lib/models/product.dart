import 'package:flutter/material.dart';

class Product {
  final String image;
  final String name;
  final double price;
  final double salePrice;
  final double percentDiscount;
  final bool onSale;

  Product({
    this.image,
    @required this.name,
    @required this.price,
    this.salePrice,
    this.percentDiscount,
    this.onSale,
  });

  Product.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      onSale = json['on_sale'],
      price = json['regular_price'],
      salePrice = json['actual_price'],
      percentDiscount = json['discount_percent'],
      image = json['image'];


  Map<String, dynamic> toJson() => {
    'name': name,
    'on_sale': onSale,
    'regular_price': price,
    'actual_price': salePrice,
    'discount_percent': percentDiscount,
    'image': image,
  };
}