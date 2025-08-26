import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String senderName;
  final String message;
  final String time;
  const MessageTile({
    super.key,
    required this.senderName,
    required this.message,
    required this.time,
  });

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: theme.shadowColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.senderName,
                  style: TextStyle(
                      color: theme.primaryColorDark,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.time,
                    style: TextStyle(
                        color: theme.focusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
          Text(
            widget.message,
            style: TextStyle(
              color: theme.primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }
}
