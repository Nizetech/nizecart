import 'package:flutter/material.dart';

const white = Colors.white;
const mainColor = Color(0xffEA4E4E);
const priColor = Color(0xff3634BE);
const secColor = Color(0xff293F48);

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const CustomButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(mainColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: white),
        ),
      ),
    );
  }
}

class ShopListView extends StatelessWidget {
  final double sHeight;
  final double height;
  final double width;
  final String title;
  final String subtitle;
  final String image;

  const ShopListView(
      {Key key,
      this.height,
      this.image,
      this.sHeight,
      this.subtitle,
      this.title,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sHeight,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        separatorBuilder: (ctx, i) => SizedBox(width: 10),
        itemBuilder: (ctx, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height,
                width: width,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black.withOpacity(.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  color: Color(0xff343a40),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
