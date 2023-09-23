import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatCardWidget extends StatelessWidget {
  const ChatCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
          title: Text('Demo User'),
          subtitle: Text('Last user message', maxLines: 1),
          trailing: Text(
            '12:00 PM',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
