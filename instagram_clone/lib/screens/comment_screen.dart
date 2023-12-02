import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments section"),
        centerTitle: false,
      ),
      body: CommentCard(),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          // this line is to keep the bottom navigation bar whenever a keyboard is opened!!!
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Comment as ${user.username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    widget.snap['postId'],
                    widget.snap['text'],
                    user.uid,
                    user.username,
                    user.photoUrl,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
