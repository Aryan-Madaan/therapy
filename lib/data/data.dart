import 'dart:collection';

import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePageData {
  HomePageData() {
    user = auth.currentUser;
    greeting = "Good Morning\n${user!.displayName!.trim().split(' ')[0]}";
    dataRef = database.ref("users/${user!.uid}/sessions");
    fetchData();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String greeting = "";
  int sessionsCompleted = 0;
  final int totalSessions = 30;
  final DateFormat _dateFormat = DateFormat("Hms");
  final DateFormat _dateFormatDate = DateFormat("d-M-y");
  final FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference dataRef;

  Future<void> fetchData() async {
    var data =
        await dataRef.child(_dateFormatDate.format(DateTime.now())).get();
    sessionsCompleted = data.children.length;
  }

  Future<void> addData() async {
    DatabaseReference internalReference =
        dataRef.child(_dateFormatDate.format(DateTime.now()));
    internalReference.update({
      "Session ${sessionsCompleted + 1}": _dateFormat.format(DateTime.now())
    });
    await fetchData();
  }

  Future<String> getDate(index) async {
    DatabaseReference internalReference = dataRef
        .child(_dateFormatDate.format(DateTime.now()))
        .child("Session ${index + 1}");
    var val = await internalReference.get();
    var format = val.value as String;
    var newVals = format.split(':');
    return "${newVals[0]}:${newVals[1]}";
  }

  String getGreeting() {
    return greeting;
  }

  String getProgress() {
    double progress = ((sessionsCompleted / totalSessions) * 100);
    return ("${progress.floor()}%");
  }

  double getProgressNumber() {
    double progress = (sessionsCompleted / totalSessions);
    return progress;
  }

  String getCompleted() {
    return "$sessionsCompleted Sessions";
  }

  String getRemaining() {
    return "${totalSessions - sessionsCompleted} Sessions";
  }

  int getCompletedNumber() {
    return sessionsCompleted;
  }

  int getTotal() {
    return totalSessions;
  }

  Widget dottedLine(Color color, {double length = 175}) {
    return DottedLine(
      lineLength: length,
      direction: Axis.vertical,
      dashLength: 8,
      dashColor: color,
    );
  }

  Future<LinkedHashMap<Object?, Object?>> getfullData() async {
    DatabaseReference newRef =
        dataRef.child(_dateFormatDate.format(DateTime.now()));
    var newObj = await newRef.get();
    return newObj.value as LinkedHashMap<Object?, Object?>;
  }

  Widget buildLeadingWidget(index, context) {
    if (index == 0) {
      if (index <= getCompletedNumber() - 1) {
        return Stack(
          alignment: Alignment.center,
          children: [
            dottedLine(Colors.blue, length: 150),
            Positioned(
              width: 10,
              top: 0,
              child: Container(
                height: 75,
                width: 5,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ],
        );
      } else {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            dottedLine(Colors.grey, length: 150),
            Positioned(
              width: 10,
              top: 0,
              child: Container(
                height: 75,
                width: 5,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(
                Icons.circle_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        );
      }
    } else if (index == getTotal() - 1) {
      if (index <= getCompletedNumber() - 1) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            dottedLine(Colors.blue, length: 150),
            Positioned(
              width: 10,
              bottom: 0,
              child: Container(
                height: 75,
                width: 5,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ],
        );
      } else {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            dottedLine(Colors.grey, length: 150),
            Positioned(
              width: 10,
              bottom: 0,
              child: Container(
                height: 75,
                width: 5,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(
                Icons.circle_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        );
      }
    } else {
      if (index <= getCompletedNumber() - 1) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            dottedLine(Colors.blue),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ],
        );
      } else {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            dottedLine(Colors.grey),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Icon(
                Icons.circle_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        );
      }
    }
  }

  Future<Widget> cardTextGenrator(index) async {
    if (index < getCompletedNumber() - 1) {
      return Container(
        padding: const EdgeInsets.only(right: 15, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Session ${index + 1}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
                    color: Colors.blue,
                    child: const Text(
                      "Completed",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    )),
              ),
            ),
            const Text(
              "Performed At",
              style: TextStyle(color: Colors.grey),
            ),
            FutureBuilder<String>(
                future: getDate(index),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }))
          ],
        ),
      );
    } else if (index == getCompletedNumber() - 1) {
      return Container(
        padding: const EdgeInsets.only(right: 15, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Session ${index + 1}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
                    color: Colors.amber,
                    child: const Text(
                      "Performed",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    )),
              ),
            ),
            const Text(
              "Enter Pain Score",
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              children: [
                const Icon(Icons.replay_outlined),
                const SizedBox(
                  width: 25,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: const Color.fromARGB(255, 221, 216, 216),
                    child: const Text(
                      "Retry",
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(right: 15, left: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Session ${index + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        color: Colors.blue,
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        color: const Color.fromARGB(255, 221, 216, 216),
                        child: const Text(
                          "Start",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
      );
    }
  }
}
