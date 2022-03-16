import 'package:flutter/material.dart';
import 'package:ristask/db/task_database.dart';
import 'package:ristask/model/task.dart';
import 'package:ristask/pages/about_page.dart';
import 'package:ristask/pages/task_form_page.dart';
import 'package:ristask/utils/constant.dart';
import 'package:ristask/utils/extension/date_time_extension.dart';
import 'package:ristask/widgets/texts/small_text.dart';
import 'package:ristask/widgets/texts/subtitle_text.dart';
import 'package:ristask/widgets/texts/title_text.dart';

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({Key? key}) : super(key: key);

  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  TaskDatabase taskDatabase = TaskDatabase();

  bool dbIsOpen = false;

  @override
  void initState() {
    initDatabase();
    super.initState();
  }

  initDatabase() async {
    bool isOpen = await taskDatabase.initDatabase();
    setState(() {
      dbIsOpen = isOpen;
    });
  }

  TitleText? _titleText;
  SubTitleText? _subText;
  SmallText? _smallText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              buildHeader(),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (_subText = SubTitleText()..text = 'Ongoing Task').child,
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                  child: !dbIsOpen
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(
                                color: progressColor,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Generating database... Please wait!')
                            ],
                          ),
                        )
                      : FutureBuilder(
                          future: taskDatabase.getTask(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Something went wrong.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.red.shade300),
                                ),
                              );
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                (!snapshot.hasData ||
                                    (snapshot.data as List).isEmpty)) {
                              return Center(
                                child: Text('Data Unavailable'),
                              );
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData &&
                                (snapshot.data as List).length > 0) {
                              var tasks = snapshot.data as List<Task>;

                              return ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) {
																		print(tasks[index].date);
                                    return buildTaskCard(tasks[index]);
                                  });
                            }
                            return const SizedBox.shrink();
                          }))
            ],
          ),
        ),
        floatingActionButton: floatingButton());
  }

  Widget floatingButton() {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      onPressed: () async {
        final back = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const TaskFormPage()));
        if (back != null) {
          if (back) {
            setState(() {});
          }
        }
      },
      child: Icon(Icons.add_rounded),
    );
  }

  showConfirmationDialog(
      {required String title,
      required String content,
      String? continueButtonText,
      Function()? onPressed}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(primary: buttonColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: buttonColor),
                  onPressed: onPressed,
                  child: Text(continueButtonText ?? 'Continue'))
            ],
          );
        });
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (_titleText = TitleText()..text = 'Welcome').child,
              (_smallText = SmallText()
                    ..text = 'Hope you have a wonderful day'
                    ..color = secondaryColor)
                  .child,
            ],
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutPage()));
              },
              child: Icon(
                Icons.person,
                color: Colors.red.shade400,
              ))
        ],
      ),
    );
  }

  Widget circleIconButton(
      {IconData? icon, Color? backgroundColor, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: Color(0xffF2F0F0),
        ),
      ),
    );
  }

  Widget buildTaskCard(Task task) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Color(0xffFBFBFB),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: -1,
                blurRadius: 8,
                offset: Offset(0, 2))
          ]),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Text(
                  task.title!,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
              ),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      circleIconButton(
                          icon: Icons.edit_rounded,
                          backgroundColor: progressColor,
                          onTap: () async {
                            final edit = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => TaskFormPage(
                                          task: task,
                                        )));
                            if (edit != null) {
                              if (edit) {
                                setState(() {});
                              }
                            }
                          }),
                      const SizedBox(
                        width: 8,
                      ),
                      circleIconButton(
                          icon: Icons.delete_rounded,
                          backgroundColor: buttonColor,
                          onTap: () {
                            showConfirmationDialog(
                                title: 'Remove Task',
                                content:
                                    'Would you like to remove ${task.title}?',
                                continueButtonText: 'Remove',
                                onPressed: () async {
                                  final count =
                                      await taskDatabase.delete(task.id!);
                                  if (count > 0) {
                                    Navigator.pop(context);
                                  }
                                  setState(() {});
                                });
                          }),
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Flexible(
              fit: FlexFit.tight,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.timer_rounded,
                      size: 18,
                      color: primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    (_smallText = SmallText()
                          ..text = DateTime.parse(task.date!).getDateOnly() +
                              ' | ' +
                              task.time!
                          ..size = 10.0
                          ..weight = FontWeight.w300
                          ..color = primaryColor)
                        .child,
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
