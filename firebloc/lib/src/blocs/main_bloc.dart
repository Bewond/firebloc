import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:firebloc/src/blocs/main_event.dart';
import 'package:firebloc/src/blocs/main_state.dart';

import 'package:firebloc/src/repositories/main_repository.dart';

/*
* This is the generic block that is used to recover data from Firebase.
* Requires the type of data model you intend to use.
* */

class Firebloc<Type> extends Bloc<FireblocEvent, FireblocState> {
  final FireblocRepository<Type> _repository;
  StreamSubscription? _subscription;

  Firebloc({required repository})
      : assert(repository != null),
        _repository = repository,
        super(Starting());

  @override
  Stream<FireblocState> mapEventToState(FireblocEvent event) async* {
    if (event is FetchData) {
      yield* _mapFetchDataToState();
    } else if (event is UpdateData<Type>) {
      yield* _mapUpdateDataToState(event);
    }
  }

  Stream<FireblocState> _mapFetchDataToState() async* {
    await _subscription?.cancel();
    _subscription = _repository
        .getData()
        .listen((result) => add(UpdateData<Type>(data: result)));
  }

  Stream<FireblocState> _mapUpdateDataToState(UpdateData<Type> event) async* {
    yield Success<Type>(data: event.data);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
