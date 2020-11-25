import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebloc/firebloc.dart';

/*
* FireblocBuilder is a BlocBuilder wrapper to simplify its use with Firebloc.
* If a function is not defined returns defaultWidget.
* */

class FireblocBuilder<Type> extends StatelessWidget {
  final Widget Function(BuildContext context)? starting;
  final Widget Function(List<Type> data)? success;
  final Widget Function()? loading;
  final Widget Function()? error;

  final Widget? defaultWidget;

  final Firebloc? cubit;

  const FireblocBuilder({
    this.starting,
    this.success,
    this.loading,
    this.error,
    this.defaultWidget,
    this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Firebloc, FireblocState>(
      cubit: cubit,
      builder: (context, state) {
        if (state is Starting) {
          return starting?.call(context) ?? _defaultFunction();
        } else if (state is Success<Type>) {
          return success?.call(state.data) ?? _defaultFunction();
        } else if (state is Loading) {
          return loading?.call() ?? _defaultFunction();
        } else if (state is Error) {
          return error?.call() ?? _defaultFunction();
        } else {
          return defaultWidget ?? Container();
        }
      },
    );
  }

  Widget _defaultFunction() {
    return defaultWidget ?? Container();
  }
}
