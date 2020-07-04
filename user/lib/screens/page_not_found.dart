import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 4),
            CircleAvatar(
              child: Image.asset('assets/face-shield-girl.png',
                  fit: BoxFit.scaleDown),
              backgroundColor: Colors.transparent,
              radius: MediaQuery.of(context).size.height / 4,
            ),
            SizedBox(height: 24),
            Expanded(
              child: Text(
                "Page Not Found!",
                style: TextStyle(fontSize: 32, color: Colors.orange),
              ),
            )
          ],
        ),
      ),
    );
  }
}
