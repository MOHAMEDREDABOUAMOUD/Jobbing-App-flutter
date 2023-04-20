import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signin_signup/pages/payment_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  DateTime? selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  void _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        timeController.text =
            DateFormat("hh:mm a").format(DateTime(2000, 1, 1, pickedTime.hour, pickedTime.minute));
      });
    }
  }

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
      });
    }
  }

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
    timeController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  backgroundColor: Colors.white,
  body: SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.04),
            Text(
              "Make This Info",
              style: TextStyle(fontSize: 30, color: Colors.orange),
            ),
            Text(
              "Welcome !",
              style: TextStyle(fontSize: 30, color: Colors.orange),
            ),
            SizedBox(height: height * 0.05),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Enter Date",
              ),
              readOnly: true,
              onTap: _showDatePicker,
            ),
            SizedBox(height: height * 0.05),
            TextFormField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: "Enter Time",
                icon: Icon(Icons.alarm),
              ),
              readOnly: true,
              onTap: _showTimePicker,
            ),
            SizedBox(height: height * 0.08),
            TextFormField(
              minLines: 2,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Enter A Order here",
                hintStyle: TextStyle(
                  color: Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),

          Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        onPressed: (){
          //hna areda dir dikchi f database w 3ad ana ndwzk l page d payment w page payment madirhach f database khliha hakak 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaymentScreen())
            );
        },
        child: Icon(Icons.navigate_next),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
        ),
      ),
    ),
  ],
)


          ],
        ),
      ),
    ),
  ),
);

  }
}
