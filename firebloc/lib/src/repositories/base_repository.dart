import 'package:meta/meta.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebloc/src/repositories/main_repository.dart';

/*
* This class provides a basic repository for queries
* that only need to retrieve all documents in a Firestore collection.
*
* If you use this repository, you still need to create a model for the data
* and specify the type of the model to the BaseRepository.
* */

class BaseRepository<Type> extends FireblocRepository<Type> {
  final String collectionName;
  final Type Function(DocumentSnapshot snap) fromSnapshot;

  BaseRepository({
    @required this.collectionName,
    @required this.fromSnapshot,
  });

  //Get list of model Type from Firestore.
  @override
  Stream<List<Type>> getData() {
    var collection = Firestore.instance.collection(collectionName);

    return collection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => fromSnapshot(doc)).toList();
    });
  }
}
