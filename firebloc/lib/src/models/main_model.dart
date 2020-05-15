import 'package:meta/meta.dart';

/*
* Classes representing data models must extend from this FireblocData.
* We recommend implementing a static method fromSnapshot within the model
* if you are using the BaseRepository and not a custom one.
* */

@immutable
abstract class FireblocData {
  FireblocData();

  //Get Firestore document of FireblocData.
  Map<String, Object> toDocument();
}
