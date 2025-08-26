import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/view_buttons.dart';

class CustomPageShifter extends StatelessWidget {
  const CustomPageShifter(
      {super.key,
      required this.onBackPressed,
      required this.onForwardPressed,
      this.startPage,
      this.endPage,
      this.page,
      this.totalPage,
      required this.onTap,
      required this.canBack,
      required this.canForward,
      this.onSearchPage,
      this.commentCount,
      this.searchTextController});
  final Function() onBackPressed, onForwardPressed;
  final Function()? startPage, endPage;
  final dynamic Function(String)? onSearchPage;
  final TextEditingController? searchTextController;
  final bool canBack, canForward;
  final int? page;
  final int? totalPage;
  final void Function()? onTap;
  final int? commentCount;

  final double iconSize = 30;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        alignment: WrapAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ViewButton(
                  buttonString: "$comments ($commentCount) ", onTap: onTap),

              const SizedBox(width: 10),

              /// page no. text
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      '$page/$totalPage',
                      style:
                          TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                ],
              ),

              /// Icons
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: iconSize,
                    onPressed: canBack ? onBackPressed : null,
                    icon: Icon(Icons.navigate_before_rounded,
                        color: canBack
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.5)),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                      height: 32,
                      // width: 55,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Text("$page"),
                      )),
                  const SizedBox(width: 5),
                  IconButton(
                    iconSize: iconSize,
                    onPressed: canForward ? onForwardPressed : null,
                    icon: Icon(Icons.navigate_next_rounded,
                        color: canForward
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.5)),
                  ),
                  const SizedBox(width: 5),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
