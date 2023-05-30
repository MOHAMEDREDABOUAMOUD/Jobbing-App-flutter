import 'package:flutter/material.dart';
import 'package:signin_signup/pages/ChangePhoto.dart';
import 'package:signin_signup/pages/changename.dart';
import 'package:signin_signup/pages/changenumber.dart';
import 'package:signin_signup/pages/changepassword.dart';
import 'package:signin_signup/pages/report.dart';
class Settings_Screen extends StatefulWidget {
  const Settings_Screen({super.key});

  @override
  State<Settings_Screen> createState() => _Settings_ScreenState();
}

class _Settings_ScreenState extends State<Settings_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Settings", style: TextStyle(fontSize: 22)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 40,),
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: Colors.orange,
                ),
                SizedBox(width: 10,),
                Text("security", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

              ],
            ),
            Divider(height: 40, thickness: 1,),
            SizedBox(height: 10,),
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Change Number Phone"),
            SizedBox(height: 40,),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.orange,
                ),
                SizedBox(width: 10,),
                Text("personal informations", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

              ],
            ),
            Divider(height: 10, thickness: 1,),
            SizedBox(height: 10,),
            buildAccountOption(context, "Change Name User"),
            buildAccountOption(context, "Change Photo"),
            
            SizedBox(height: 40,),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.orange,
                ),
                SizedBox(width: 10,),
                Text("Report", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

              ],
            ),
            Divider(height: 10, thickness: 1,),
            SizedBox(height: 10,),
            buildAccountOption(context, "report"),
          ],
          
        ),
        
      ),
    );
  }
  GestureDetector buildAccountOption(BuildContext context,String title){
    return GestureDetector(
      onTap: () {
        if (title == "Change Password") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePassword(key: UniqueKey())),
            );
          } else if (title == "Change Number Phone") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangeNumber()),
            );
          }else if (title == "Change Name User"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangeName()),
            );
          }else if(title == "Change Photo"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePhoto()),
            );
          }else if(title == "report"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportScreen()),
            );
          }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]
            )),
            Icon(Icons.arrow_forward_ios, color: Colors.grey,)
          ],
        ),
      ),
    );
  }
}