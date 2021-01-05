import 'package:flutter/material.dart';

class CalendarListTile extends StatelessWidget {
  String name;
  CalendarListTile(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      child: ListTile(
        title: Row(
          children: [
            Icon(Icons.crop_square, size: 50.0),
            SizedBox(width: 20.0),
            Text(
              name,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
                width: 50.0,
                child: FlatButton(onPressed: () {}, child: Icon(Icons.share))),
            SizedBox(
                width: 50.0,
                child: FlatButton(
                  onPressed: () {},
                  child: Icon(Icons.delete),
                )),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
