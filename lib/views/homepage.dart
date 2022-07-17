// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:therapy/data/data.dart';

class HomePage extends StatefulWidget {
  final HomePageData _homePageData;
  const HomePage(this._homePageData, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(
        _homePageData,
      );
}

class _HomePageState extends State<HomePage> {
  final HomePageData _homePageData;
  final ScrollController _controller = ScrollController();
  _HomePageState(
    this._homePageData,
  );

  @override
  void initState() {
    super.initState();
    _homePageData.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  _homePageData.getGreeting(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 3),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Today's Progress",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 86, 80, 80),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                              Text(
                                _homePageData.getProgress(),
                                style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            child: LinearProgressIndicator(
                              value: _homePageData.getProgressNumber(),
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.check_box_outlined,
                                          color: Colors.green, size: 40),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Completed"),
                                          Text(
                                            _homePageData.getCompleted(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ]),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.arrow_forward_outlined,
                                      color: Colors.blue,
                                      size: 40,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Pending"),
                                        Text(
                                          _homePageData.getRemaining(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        SliverPadding(
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 30, right: 15, left: 15),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _homePageData.buildLeadingWidget(index, context),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Opacity(
                          opacity:
                              index < (_homePageData.getCompletedNumber() - 1)
                                  ? 0.7
                                  : 1,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey, offset: Offset(4, 4))
                                ],
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            // height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FutureBuilder<Widget>(
                                    future:
                                        _homePageData.cardTextGenrator(index),
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.data!;
                                      } else {
                                        return Container(
                                          child: const CircularProgressIndicator(),
                                        );
                                      }
                                    })),
                                const SizedBox(
                                  width: 30,
                                ),
                                ClipRRect(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(5)),
                                  child: Image(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      fit: BoxFit.fitWidth,
                                      image:
                                          const AssetImage('assets/rootallyai.jpeg')),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]);
              },
              childCount: 30,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
      ],
    );
  }
}
