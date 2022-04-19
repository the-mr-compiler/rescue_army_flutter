import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../utils/constants.dart';
import '../models/event.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Future<List<Event>> fetchEvents() async {
    final request =
        await get(Uri.parse(Constants.API_ENDPOINT + "/events/"), headers: {
      'Authorization':
          "Token " + await FirebaseAuth.instance.currentUser!.getIdToken()
    });
    List<Event> events = jsonDecode(request.body);
    return events;
  }

  @override
  void initState() {
    fetchEvents().then((value) => print(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        toolbarHeight: 80,
        title: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.search),
            hintText: "Search upcoming events",
            hintStyle:
                Theme.of(context).textTheme.caption!.copyWith(fontSize: 18),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Offline Events",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    EventCard(),
                    EventCard(),
                    EventCard(),
                    EventCard(),
                    EventCard(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      ),
                      tooltip: "Show More",
                    )
                  ],
                ),
              ),
              Text(
                "Online Events",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    EventCard(),
                    EventCard(),
                    EventCard(),
                    EventCard(),
                    EventCard(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      ),
                      tooltip: "Show More",
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatefulWidget {
  const EventCard({
    Key? key,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 200,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Image(
              image: AssetImage('assets/images/flag.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "kjhfsd sdhfj hhdkjfk hsdkf hdkf s dfjhsjk dfhk sdsdffh dfsd sdf",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            ButtonBar(
              buttonPadding: EdgeInsets.zero,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isSaved = !isSaved;
                    });
                  },
                  icon: isSaved
                      ? Icon(
                          Icons.bookmark,
                          color: Theme.of(context).primaryColor,
                        )
                      : Icon(Icons.bookmark_border_outlined),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}