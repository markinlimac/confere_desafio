import 'package:confere/models/product.dart';
import 'package:flutter/cupertino.dart';

class ViewProductsState {

}

class ViewProductsLoadingState extends ViewProductsState {

}

class ViewProductsErrorState extends ViewProductsState {
  final String message;

  ViewProductsErrorState({@required this.message});
}

class ViewProductsLoaded extends ViewProductsState {
  final List<Product> list;

  ViewProductsLoaded({@required this.list});
}

class ViewProductsStateEmptyList extends ViewProductsState {}
