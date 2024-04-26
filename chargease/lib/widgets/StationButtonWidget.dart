import 'package:flutter/material.dart';

class StationButtonWidget extends StatelessWidget {
  final String imageUrl;
  final String stationName;
  final Function()? onTap;

  const StationButtonWidget({
    required this.imageUrl,
    required this.stationName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 250,
          height: 20,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 250, 248),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
                spreadRadius: 2,
                offset: Offset(1, 2),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  imageUrl,
                  scale: 5,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stationName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
