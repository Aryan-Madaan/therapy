import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:therapy/data/data.dart';

class Rehab extends StatefulWidget {
  const Rehab(this._homePageData, {Key? key}) : super(key: key);
  final HomePageData _homePageData;

  @override
  State<Rehab> createState() => _RehabState(_homePageData);
}

class _RehabState extends State<Rehab> {
  final HomePageData _homePageData;
  final DateFormat _dateFormatDate = DateFormat("d-M-y");

  _RehabState(this._homePageData);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Rehab Programme",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.blue,
                        Colors.lightBlue,
                        Colors.lightBlueAccent,
                        Colors.blueAccent
                      ]),
                    ),
                    //Color.fromARGB(255, 39, 128, 201),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Knee Rehab\nProgramme",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(
                            height: 7,
                          ),
                          const Text(
                            "Mon, Thu, Sat\n3 Sessions/day",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              child: const Text(
                                "Left Shoulder",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 39, 128, 201),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Assigned By",
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Jane Doe",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "History",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.filter_alt,
                        size: 32,
                      )
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: const Color.fromARGB(255, 221, 222, 223),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text("Total Sessions",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 130, 128, 128),
                                )),
                            Row(
                              children: [
                                const Icon(
                                  Icons.sports_gymnastics,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                                Text(_homePageData
                                    .getCompletedNumber()
                                    .toString())
                              ],
                            )
                          ],
                        ),
                        Container(
                          color: Colors.black12,
                          height: 30,
                          width: 1.5,
                        ),
                        Column(
                          children: [
                            const Text("Total Time",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 130, 128, 128),
                                )),
                            Row(
                              children: [
                                const Icon(
                                  Icons.hourglass_bottom,
                                  color: Color.fromARGB(255, 204, 145, 124),
                                  size: 30,
                                ),
                                Text(_homePageData
                                    .getCompletedNumber()
                                    .toString())
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ])),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return FutureBuilder<LinkedHashMap<Object?, Object?>>(
                  future: _homePageData.getfullData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      LinkedHashMap<Object?, Object?> map =
                          snapshot.data as LinkedHashMap<Object?, Object?>;
                      return ListTile(
                        minVerticalPadding: 15,
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset("assets/rootallyai.jpeg")),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.alarm,
                                  size: 20,
                                ),
                                Text(
                                  map["Session ${index + 1}"] as String,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                ),
                                Text(_dateFormatDate.format(DateTime.now()))
                              ],
                            )
                          ],
                        ),
                        trailing: const Text("View Results"),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Icon(Icons.error_sharp),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            },
            childCount: _homePageData.getCompletedNumber(),
          )),
        )
      ],
    );
  }
}
