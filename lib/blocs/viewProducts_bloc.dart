import 'package:confere/blocs/viewProducts_event.dart';
import 'package:confere/blocs/viewProducts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewProductsBloc extends Bloc<ViewProductsEvent, ViewProductsState> {
  ViewProductsBloc(ViewProductsState initialState) : super(ViewProductsLoadingState());

  @override
  Stream<ViewProductsState> mapEventToState(ViewProductsEvent event) async* {
    throw UnimplementedError();
  }
}