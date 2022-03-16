import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ristask/db/task_database.dart';
import 'package:ristask/model/task.dart';
import 'package:ristask/utils/constant.dart';
import 'package:ristask/utils/extension/date_time_extension.dart';
import 'package:ristask/utils/extension/string_extension.dart';
import 'package:ristask/widgets/texts/title_text.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({this.task, Key? key}) : super(key: key);
  final Task? task;

  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  bool isDone = false;
  bool isLoading = false;
  TaskDatabase taskDatabase = TaskDatabase();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    taskDatabase.initDatabase();
    initForm();
    super.initState();
  }

  initForm() {
    if (widget.task != null) {
      titleController.text = widget.task!.title!;
      timeController.text = widget.task!.time!;
      dateController.text = widget.task!.date!;
      setState(() {});
    }
  }

  TitleText? _titleText;

  selectDate() async {
    final datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.parse('2021-01-01'),
        lastDate: DateTime.parse('2024-12-31'));
    if (datePicker != null && datePicker != _selectedDate) {
      setState(() {
        _selectedDate = datePicker;
        dateController.text = datePicker.formatSaving();
      });
    }
  }

  selectTime() async {
    final timePicker =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (timePicker != null && timePicker != _selectedTime) {
      setState(() {
        _selectedTime = timePicker;
        timeController.text =
            timePicker.format(context).formatSaving(); //.formatSaving();
      });
    }
  }

  save() async {
    setState(() {
      isLoading = true;
    });
    final task = widget.task != null
        ? widget.task!.copyWith(
            title: titleController.text,
            date: dateController.text,
            time: timeController.text,
          )
        : Task(
            title: titleController.text,
            date: dateController.text,
            time: timeController.text,
          );
    final result = widget.task != null
        ? await taskDatabase.update(task)
        : await taskDatabase.create(task);

    setState(() {
      isLoading = false;
    });
    Get.snackbar(widget.task != null ? 'Update Task' : 'Create Task',
        '${widget.task != null ? "Update" : "Create"} Task Successfully',
        backgroundColor: Color(0xffE55E3C), colorText: Colors.white);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          title: (_titleText = TitleText()
                ..text =
                    widget.task != null ? 'UPDATE TASK' : 'CREATE NEW TASK')
              .child
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date'),
                Row(
                  children: [
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: buildInput(
                          controller: dateController, readOnly: true),
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        child: IconButton(
                            onPressed: () => selectDate(),
                            icon: Icon(Icons.calendar_today_rounded)))
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Time'),
                Row(
                  children: [
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: buildInput(
                          controller: timeController, readOnly: true),
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        child: IconButton(
                            onPressed: () => selectTime(),
                            icon: Icon(Icons.timer_rounded)))
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title'),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: buildInput(controller: titleController),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: isLoading
                ? CircularProgressIndicator(
                    color: progressColor,
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                      primary: primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      horizontal:
                          MediaQuery.of(context).size.width * 0.3)),
                    onPressed: () => save(),
                    child: Text(
                        widget.task != null ? 'UPDATE TASK' : 'CREATE TASK')),
          )
        ],
      ),
    );
  }

  Container buildInput(
      {double? height = 50,
      TextInputType? inputtype,
      bool readOnly = false,
      TextEditingController? controller}) {
    return Container(
      height: height,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 1),
            spreadRadius: -1,
            blurRadius: 6)
      ], color: Color(0xffF0F0F0), borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: inputtype,
        maxLines: 4,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
      ),
    );
  }
}
