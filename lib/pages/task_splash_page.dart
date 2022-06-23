import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristask/db/user_cache.dart';
import 'package:ristask/pages/task_home_page.dart';
import 'package:ristask/widgets/texts/small_text.dart';
import 'package:ristask/widgets/texts/subtitle_text.dart';
import 'package:ristask/widgets/texts/title_text.dart';

class TaskSplashPage extends StatefulWidget {
  const TaskSplashPage({ Key? key }) : super(key: key);

  @override
  State<TaskSplashPage> createState() => _TaskSplashPageState();
}

class _TaskSplashPageState extends State<TaskSplashPage> {
  final TextEditingController _nameController = TextEditingController();

  bool isValid = true;

  TitleText? _titleText;
  SubTitleText? _subText;
  SmallText? _smallText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeaderTitle(),
              buildImageHeader(),
              const SizedBox(
                height: 50,
              ),
              isValid
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: (_smallText = SmallText()
                            ..text = 'Name is required!'
                            ..weight = FontWeight.normal
                            ..color = Colors.red.shade300)
                          .child),
              buildInputField(),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: buildStartedButton(),
              )
            ],
          ),
        ),
      ),
    );
  }

  save(String username) async {
    if (username.isEmpty) {
      setState(() {
        isValid = false;
      });
      return;
    }
    bool isSaved = await UserCache.saveUser(_nameController.text);
    if (isSaved) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => TaskHomePage(
                user: _nameController.text,
              )));
    } else {
      Get.snackbar('Authentication Failed',
          'Something went wrong while saving user.\nPlease, try again later',
          backgroundColor: const Color(0xffE55E3C), colorText: Colors.white);
    }
  }

  Widget buildStartedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        primary: const Color(0xffE55E3C),
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: MediaQuery.of(context).size.width * 0.3
        )
      ),
      onPressed: () {
        save(_nameController.text);
      },
      child: (_subText = SubTitleText()
            ..text = 'GET STARTED'
            ..color = Colors.white
            ).child
    );
  }

  Widget buildInputField() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
          color: const Color(0xffEDEDED),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: !isValid ? Colors.red.shade400 : const Color(0xffEDEDED))),
      child: TextField(
        controller: _nameController,
        onChanged: (val) {
          if (!isValid && val.isNotEmpty) {
            setState(() {
              isValid = true;
            });
          }
        },
        decoration: const InputDecoration(
          hintText: 'Your name here . . .',
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none
        )
      ),
    );
  }

  Center buildImageHeader() {
    return Center(
      child: Image.asset(
        'assets/images/task.png',
        fit: BoxFit.cover,
        width: 230,
        height: 230,
      ),
    );
  }

  Widget buildHeaderTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 90, bottom: 50),
      child:
          (_titleText = TitleText()..text = 'Manage Your\nDaily Task Well').child,
    );
  }
}