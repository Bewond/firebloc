import 'package:equatable/equatable.dart';

//

abstract class FireblocEvent extends Equatable {
  const FireblocEvent();

  @override
  List<Object> get props => [];
}

class FetchData extends FireblocEvent {
  @override
  String toString() => 'FireblocEvent: FetchData';
}

class UpdateData<Type> extends FireblocEvent {
  final List<Type> data;

  const UpdateData({
    required this.data,
  });

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'FireblocEvent: UpdateData { data: $data }';
}
