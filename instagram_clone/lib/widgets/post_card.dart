import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap["profImage"]),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap["username"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                                'Edit',
                              ]
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList()),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),

          // Image Area
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap['postID'],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap["postUrl"],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Like Commnet section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postID'],
                      user.uid,
                      widget.snap['likes'],
                    );
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  icon: Icon(
                    widget.snap['likes'].contains(user.uid)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: widget.snap['likes'].contains(user.uid)
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CommentScreen(snap: widget.snap['postId'].toString()),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_outline,
                    ),
                  ),
                ),
              )
            ],
          ),
          // for description
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: "  ",
                        ),
                        TextSpan(
                          text: widget.snap['description'],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Text(
                          "View all 200 comments",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            DateFormat.yMMMd().format(
                              widget.snap['datePublished'].toDate(),
                            ),
                            style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
