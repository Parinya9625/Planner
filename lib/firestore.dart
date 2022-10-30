import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

Future fs_AddClass(String day, String subject, String stime, String etime,
    String room, String section, String no) async {
  Firestore.instance.runTransaction(
    (transaction) async {
      DocumentReference docRef = Firestore.instance
          .collection("classroom")
          .document(day.toLowerCase());

      await transaction.get(docRef).then(
        (doc) async {
          List data = doc.data["data"];
          Map newData = {
            "subject": subject,
            "stime": stime,
            "etime": etime,
            "room": room,
            "section": section,
            "no": no,
          };
          await transaction.update(docRef, {
            "data": data + [newData]
          });
        },
      );
    },
  );
}

Future fs_RemoveClass(String day, int index) async {
  Firestore.instance.runTransaction(
    (transaction) async {
      DocumentReference docRef = Firestore.instance
          .collection("classroom")
          .document(day.toLowerCase());
      await transaction.get(docRef).then(
        (doc) async {
          List data = doc.data["data"];
          data.removeAt(index);

          await transaction.update(docRef, {"data": data});
        },
      );
    },
  );
}

Future fs_UpdateClass(String oldDay, String day, int index, String subject,
    String stime, String etime, String room, String section, String no) async {
  Map newData = {
    "subject": subject,
    "stime": stime,
    "etime": etime,
    "room": room,
    "section": section,
    "no": no,
  };
  if (oldDay.toLowerCase() == day.toLowerCase()) {
    Firestore.instance.runTransaction(
      (transaction) async {
        DocumentReference docRef = Firestore.instance
            .collection("classroom")
            .document(oldDay.toLowerCase());
        await transaction.get(docRef).then(
          (doc) async {
            List data = doc.data["data"];
            data.removeAt(index);
            data.insert(index, newData);
            await transaction.update(docRef, {"data": data});
          },
        );
      },
    );
  } else {
    Firestore.instance.runTransaction(
      (transaction) async {
        DocumentReference docRef = Firestore.instance
            .collection("classroom")
            .document(oldDay.toLowerCase());
        await transaction.get(docRef).then(
          (doc) async {
            List data = doc.data["data"];
            data.removeAt(index);
            await transaction.update(docRef, {"data": data});
          },
        );
      },
    );
    fs_AddClass(day, subject, stime, etime, room, section, no);
  }

  // Firestore.instance.runTransaction(
  //   (transaction) async {
  //     DocumentReference docRef = Firestore.instance
  //         .collection("classroom")
  //         .document(day.toLowerCase());
  //     await transaction.get(docRef).then(
  //       (doc) async {
  //         List data = doc.data["data"];
  //         Map newData = {
  //           "subject": subject,
  //           "stime": stime,
  //           "etime": etime,
  //           "room": room,
  //           "section": section,
  //           "no": no,
  //         };
  //         await transaction.update(docRef, {
  //           "data": data + [newData]
  //         });
  //       },
  //     );
  //   },
  // );
}

Future fs_AddEvent(String title, String color, String sdate, String edate,
    String stime, String etime, String location) async {
  Firestore.instance.runTransaction((transaction) async {
    DocumentReference docRef =
        Firestore.instance.collection("event").document();

    await transaction.set(docRef, {
      "title": title,
      "color": color,
      "sdate": sdate,
      "edate": edate,
      "stime": stime,
      "etime": etime,
      "location": location
    });
  });
}

Future fs_RemoveEvent(String docID) async {
  Firestore.instance.runTransaction((transaction) async {
    DocumentReference docRef =
        Firestore.instance.collection("event").document(docID);
    await transaction.delete(docRef);
  });
}

Future fs_UpdateEvent(String docID, String title, String color, String sdate,
    String edate, String stime, String etime, String location) async {
  Firestore.instance.runTransaction((transaction) async {
    DocumentReference docRef =
        Firestore.instance.collection("event").document(docID);

    await transaction.update(docRef, {
      "title": title,
      "color": color,
      "sdate": sdate,
      "edate": edate,
      "stime": stime,
      "etime": etime,
      "location": location
    });
  });
}

Future fs_AddWork(
    String title, String color, String description, String date) async {
  Firestore.instance.runTransaction((transaction) async {
    DocumentReference docRef = Firestore.instance.collection("work").document();

    await transaction.set(docRef, {
      "title": title,
      "color": color,
      "description": description,
      "date": date
    });
  });
}

Future fs_RemoveWork(String docID) async {
  Firestore.instance.runTransaction((transaction) async {
    DocumentReference docRef =
        Firestore.instance.collection("work").document(docID);
    await transaction.delete(docRef);
  });
}

Future fs_UpdateWork(String docID, String title, String color,
    String description, String date) async {
  Firestore.instance.runTransaction((transaction) async {
    DocumentReference docRef =
        Firestore.instance.collection("work").document(docID);

    await transaction.update(docRef, {
      "title": title,
      "color": color,
      "description": description,
      "date": date
    });
  });
}

Future fs_AddNote(String title, String color, String description) async {
  Firestore.instance.runTransaction((transaction) async {
    DocumentReference docRef = Firestore.instance.collection("note").document();

    await transaction.set(
        docRef, {"title": title, "color": color, "description": description});
  });
}

Future fs_RemoveNote(String docID) async {
  Firestore.instance.runTransaction((transaction) async {
    DocumentReference docRef =
        Firestore.instance.collection("note").document(docID);
    await transaction.delete(docRef);
  });
}

Future fs_UpdateNote(
    String docID, String title, String color, String description) async {
  Firestore.instance.runTransaction((transaction) async {
    DocumentReference docRef =
        Firestore.instance.collection("note").document(docID);

    await transaction.update(
        docRef, {"title": title, "color": color, "description": description});
  });
}
// Future fs_GetSubject() async {
//   QuerySnapshot docFetch =
//       await Firestore.instance.collection("classroom").getDocuments();
//   List subject = [];
//   for (var doc in docFetch.documents) {
//     DocumentSnapshot docSnap = await Firestore.instance
//         .collection("classroom")
//         .document(doc.documentID)
//         .get();
//     if (docSnap.data["data"].length != 0) {
//       for (Map d in docSnap.data["data"]) {
//         if (subject.indexOf(d["subject"]) == -1) {
//           subject.add(d["subject"]);
//         }
//       }
//     }
//   }
//   return subject;
// }
