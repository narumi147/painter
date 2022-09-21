part of 'split_route.dart';

/// BackButton used on master page which will pop all top detail routes
/// if [onPressed] is omitted.
/// Use original [BackButton] in detail page which only pop current detail route
class MasterBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const MasterBackButton({Key? key, this.color, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackButton(
      color: color,
      onPressed: () async {
        if (SplitRoute.of(context)?.detail == false) {
          SplitRoute.popDetailRoutes(context);
        }
        if (onPressed != null) {
          onPressed!();
        } else {
          if (ModalRoute.of(context)?.isFirst != true) {
            Navigator.pop(context);
          } else {
            // won't ignore WillPopScope
            Navigator.maybePop(context);
          }
        }
      },
    );
  }
}
