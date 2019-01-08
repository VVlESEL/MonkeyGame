import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("leaderboard")
          .orderBy("score", descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading...");
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return _buildListItem(
                  context, index + 1, snapshot.data.documents[index]);
            });
      },
    );
  }

  Widget _buildListItem(
      BuildContext context, int rank, DocumentSnapshot document) {

    Color color = Colors.brown.shade800;
    switch(rank){
      case 1: color = Colors.yellow; break;
      case 2:
      case 3:
      case 4:
      case 5: color = Colors.orangeAccent; break;
      case 6:
      case 7:
      case 8:
      case 9:
      case 10: color = Colors.deepOrangeAccent; break;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(
          rank.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(document["name"].toString(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),),
      trailing: Text(document["score"].toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),),
    );
  }
}
