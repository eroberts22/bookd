import 'package:flutter/material.dart';

class LadingPageButton extends StatelessWidget {
  final String text;
  final ImageProvider? image;
  final Color? color;
  final ElevatedButton? icon;

  const LadingPageButton({
    Key? key,
    required this.text,
    this.image,
    this.color,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(2),
        overlayColor: MaterialStateProperty.all(Colors.black12),
        shadowColor: MaterialStateProperty.all(Colors.pink.shade50),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        fixedSize: MaterialStateProperty.all(const Size(412, 60)),
      ),
      child: Row(children: [
        ImageIcon(image, size: 30, color: color),
        const Spacer(),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
      ]),
    );
  }
}
