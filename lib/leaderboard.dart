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
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return _buildListItem(
                  context, index+1, snapshot.data.documents[index]);
            });
      },
    );
  }

  Widget _buildListItem(
      BuildContext context, int rank, DocumentSnapshot document) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(rank.toString()),
      ),
      title: Text(document["name"].toString()),
      trailing: Text(document["score"].toString()),
    );
  }
}
