import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed.dart';
import 'package:instagram_clone/screens/search_screen.dart';

const webScreenSize = 600;

const HomeScreens = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("Notification"),
  Text("Profile"),
];
