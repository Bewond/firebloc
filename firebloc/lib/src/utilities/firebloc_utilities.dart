import 'package:flutter/material.dart';

import 'package:firebloc/firebloc.dart';

//

class FireblocUtilities {
  /*
  * A function to simplify the writing of the code
  * when you need to return a different Widget depending on the FireblocState.
  * */
  static Widget stateToWidget(
    BuildContext context,
    FireblocState state, {
    required Widget Function(BuildContext context) starting,
    required Widget Function(List<Type> data) success,
    required Widget Function() loading,
    required Widget Function() error,
    Widget? defaultWidget,
  }) {
    if (state is Starting) {
      return starting(context);
    } else if (state is Success<Type>) {
      return success(state.data);
    } else if (state is Loading) {
      return loading();
    } else if (state is Error) {
      return error();
    } else {
      return defaultWidget ?? Container();
    }
  }
}
