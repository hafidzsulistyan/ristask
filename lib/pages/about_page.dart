import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: const Text(
            'ABOUT ME',
            style: TextStyle(color: Colors.black),
          )
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const CircleAvatar(
                maxRadius: 100,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const Padding(
                padding: EdgeInsets.all(32.0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Nama Lengkap',
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    'Muhammad Hafidz Sulistyanto',
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  Text(
                    'Nama Panggilan',
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    'Hafidz',
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  Text(
                    'Hobi',
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    'Gak ngapa-ngapain',
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}