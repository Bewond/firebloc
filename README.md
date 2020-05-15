# Firebloc
A small library to simplify the use of bloc to manage the states of simple queries to Firebase.

---

# Overview
### Example of BaseRepository
This example shows how to use BaseRepository to retrieve data from a collection by creating only the data model.

**Data model** (`disocverLabel.dart`):
```dart
import 'package:meta/meta.dart';

import 'package:firebloc/firebloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DiscoverLabel extends FireblocData {
  final String text;
  final String description;

  DiscoverLabel({
    @required this.text,
    @required this.description,
  });

  @override
  Map<String, Object> toDocument() {
    return {
      "text": text,
      "description": description,
    };
  }

  //

  static DiscoverLabel fromSnapshot(DocumentSnapshot snap) {
    return DiscoverLabel(
      text: snap.data['text'],
      description: snap.data['description'],
    );
  }
}
```

Classes representing data models must extend from `FireblocData`.
We recommend implementing a static method `fromSnapshot` within the model.

**Using the bloc**:
```dart
BlocProvider<Firebloc>(
  create: (context) => Firebloc<DiscoverLabel>(
    repository: BaseRepository<DiscoverLabel>(
      collectionName: 'mainLabels', //The collection from which to recover data.
      fromSnapshot: DiscoverLabel.fromSnapshot,
    ),
  ),
  child: BlocBuilder<Firebloc, FireblocState>(
    builder: (context, state) {
      //Fetch data.
      if (state is Starting)
        BlocProvider.of<Firebloc>(context).add(FetchData());

      //Access to data.
      if (state is Success) {
        DiscoverLabel firstLabel = state.data[0];
        print(firstLabel.text);
        print(firstLabel.description);
        
        return Text('Success');
      }
      
      //Loading indicator.
      else if (state is Loading)
        return CircularProgressIndicator();
        
      //Error message.
      else
        return Text('Error');
    },
  ),
)
```

### Example with a custom repository
When the query to be executed is more complex, a customized repository and data model can be created. \
The classes that represent repositories must extend from `FireblocRepository`
and specify the custom type of data model you intend to use.

The model is the same as in the previous example (`disocverLabel.dart`).

**Data Repository** (`discoverRepository.dart`):

```dart
import 'package:firebloc/firebloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bddelivery/models/discoverLabel.dart';


class DiscoverRepository extends FireblocRepository {
  final _collection = Firestore.instance.collection('mainLabels');

  @override
  Stream<List> getData() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => DiscoverLabel.fromSnapshot(doc))
          .toList();
    });
  }
}
```

The use of the bloc is very similar to the previous example,
just modify the repository definition to use the custom one.

**Using the bloc**:

```dart
BlocProvider<Firebloc>(
  create: (context) => Firebloc<DiscoverLabel>(
    repository: DiscoverRepository(),
  ),
  child: BlocBuilder<Firebloc, FireblocState>(
    builder: (context, state) {
      //...
    },
  ),
)
```

### FireblocUtilities

**stateToWidget**: \
`FireblocUtilities.stateToWidget`
A function to simplify the writing of the code when you need to return a different Widget depending on the FireblocState.

```dart
BlocProvider<Firebloc>(
  create: (context) => Firebloc<DiscoverLabel>(
    repository: BaseRepository<DiscoverLabel>(
      collectionName: 'mainLabels',
      fromSnapshot: DiscoverLabel.fromSnapshot,
    ),
  ),
  child: BlocBuilder<Firebloc, FireblocState>(
    builder: (context, state) => FireblocUtilities.stateToWidget(
      context,
      state,
      starting: (context) {
        BlocProvider.of<Firebloc>(context).add(FetchData());
        return Container();
      },
      success: (data) {
        DiscoverLabel firstLabel = data[0];
        print(firstLabel.text);
        print(firstLabel.description);

        return Text('Success');
      },
      loading: () => CircularProgressIndicator(),
      error: () => Text('Error'),
    ),
  ),
)
```
---
