<h1 align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="/docs/assets/firebloc_dark.png">
    <img alt="Firebloc" src="/docs/assets/firebloc.png">
  </picture>
</h1>

## Overview

A small library for [Flutter](https://flutter.dev/) to simplify the use of [bloc](https://bloclibrary.dev/) to manage the states of simple queries to [Firebase](https://firebase.google.com/docs/firestore).

(Currently in beta)

- [Installing](#installing)
- [Documentation](#documentation)
  - [Example of BaseRepository](#example-of-baserepository)
  - [Example with a custom repository](#example-with-a-custom-repository)
  - [Advanced use case](#advanced-use-case)
- [Useful widgets and functions](#useful-widgets-and-functions)
  - [Firebloc Widgets](#firebloc-widgets)
  - [Firebloc Utilities](#firebloc-utilities)
- [Maintainers](#maintainers)

## Installing

#### Depend

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  firebloc:
    git:
      url: git://github.com/bewond/firebloc.git
      path: firebloc
```

#### Install

You can install packages from the command line:

```shell
flutter pub get
```

## Documentation

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
      fromSnapshot: DiscoverLabel.fromSnapshot, //Static method implemented in the model.
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


class DiscoverRepository extends FireblocRepository<DiscoverLabel> {
  final _collection = FirebaseFirestore.instance.collection('mainLabels');

  @override
  Stream<List<DiscoverLabel>> getData() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
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

### Advanced use case

**Custom Bloc with custom repository**: \
Just define the new events you want to use, the events and base states are contained in Firebloc. \
However, it is still necessary to map all the events used in the bloc, including those contained in Firebloc, in particular UpdateData. \
In this case it is no longer necessary for the repository to extend from `FireblocRepository`.

## Useful widgets and functions

Firebloc provides some tools to make coding more efficient and concise.

### Firebloc Widgets

**FireblocBuilder**: \
`FireblocBuilder` A BlocBuilder wrapper to simplify its use with Firebloc.
If a function for a specific state is not defined, it returns optional parameter `defaultWidget`.

```dart
FireblocBuilder<DiscoverLabel>(
  starting: (context) {
    BlocProvider.of<Firebloc>(context).add(FetchData());
    return Container();
  },
  success: (List<DiscoverLabel> data) {
    if (data.isNotEmpty)
      return Text('Success: ${data.length}');
    else
      return Text('Page not found');
  },
)
```

### Firebloc Utilities

**stateToWidget**: \
`FireblocUtilities.stateToWidget`
A function to simplify the writing of the code when you need to return a different Widget depending on the FireblocState.
You must also specify the data type, in this case `DiscoverLabel`, to make the type explicit in the `success` function.

```dart
BlocProvider<Firebloc>(
  create: (context) => Firebloc<DiscoverLabel>(
    repository: BaseRepository<DiscoverLabel>(
      collectionName: 'mainLabels',
      fromSnapshot: DiscoverLabel.fromSnapshot,
    ),
  ),
  child: BlocBuilder<Firebloc, FireblocState>(
    builder: (context, state) => FireblocUtilities.stateToWidget<DiscoverLabel>(
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

If necessary, you can specify a default Widget using the optional `defaultWidget` parameter.

---

## Maintainers

- [Riccardo Brero](https://github.com/Riki1312)
