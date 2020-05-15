import 'package:meta/meta.dart';

/*
* The classes that represent repositories must extend
* from this FireblocRepository and specify the custom
* type of data model you intend to use.
* */

@immutable
abstract class FireblocRepository<Type> {
  FireblocRepository();

  //Get list of data from Firestore.
  Stream<List<Type>> getData();
}
