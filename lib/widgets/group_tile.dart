import 'package:enelsis_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String username;
  final String groupId;
  final String groupName;
  final String rool;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.username,
      required this.rool})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              username: widget.username,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          
          subtitle: widget.rool == 'Admin' ? Text(
            '"${widget.groupName}" grubunu oluşturdunuz',
            // "Join the conversation as ${widget.username}",
            style: const TextStyle(fontSize: 13),
          ) : Text('"${widget.groupName}" grubuna katıldınız"'),
        ),
      ),
    );
  }
}
