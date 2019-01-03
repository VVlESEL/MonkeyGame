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
      stream: Firestore.instance.collection("leaderboard").snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return const Text("Loading...");
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              _buildListItem(context, snapshot.data.documents[index]);
            });
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(document["score"]),
      ),
      title: document["name"],
    );
  }
}