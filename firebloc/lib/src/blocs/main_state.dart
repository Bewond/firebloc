import 'package:equatable/equatable.dart';

//

abstract class FireblocState extends Equatable {
  const FireblocState();

  @override
  List<Object> get props => [];
}

class Starting extends FireblocState {
  @override
  String toString() => 'FireblocState: Starting';
}

class Loading extends FireblocState {
  @override
  String toString() => 'FireblocState: Loading';
}

class Failure extends FireblocState {
  @override
  String toString() => 'FireblocState: Failure';
}

class Success<Type> extends FireblocState {
  final List<Type> data;

  const Success({
    required this.data,
  });

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'FireblocState: Success { data: $data }';
}
