// ignore_for_file: prefer_const_constructors
//import 'qrinspect.dart';
//import 'buildcard.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/apis.dart';
import 'viewcategory.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List allQrs=[];
  false;
  
  @override
  void initState() {
    listAllqrs();
    // TODO: implement initState
    super.initState();
  }

  listAllqrs()async{
    print("api called");
    bool =true;

   var res = await ApiS().listAllQrs();
   false;
   if(res!="error"){
    setState(() {
      allQrs=res.toList();
    });

   }
   print("qrr: $allQrs");
  }


   @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: 
      (bool==true)?CircularProgressIndicator():
      Column(
        children: [
          (allQrs.isEmpty)? Text("no data"):
          ListView.builder(
            itemCount: allQrs.length,
            shrinkWrap: true,
                
                itemBuilder: (context, index) {

                  return Container(
                    
                    child: Image.network("${allQrs[index]['image_url']}"),);
                
              },),
          Container(
            child: Center(
              child: Text('Home Page Content'),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: MediaQuery.sizeOf(context).width*0.31,
        child: FloatingActionButton(
          onPressed: () {
            ShowModalSheet(context);
          },          
          child: Text('Categories', style: _textTheme.bodySmall?.copyWith(color: Colors.black)),
        ),
      ),
    );
  }
}


void ShowModalSheet (BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      TextTheme _textTheme = Theme.of(context).textTheme;
      return Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(14, 17, 0, 0),
                child: Text('Categories', style: _textTheme.bodyLarge),
              ),
              SizedBox(height: 15),
              ListTile(
                leading: Icon(Icons.sports_basketball),
                title: Text('Sports', style: _textTheme.bodyMedium),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryView(title: 'Sports')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.fastfood),
                title: Text('Food', style: _textTheme.bodyMedium),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryView(title: 'Food')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.wifi),
                title: Text('Technology', style: _textTheme.bodyMedium),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryView(title: 'Technology')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Education', style: _textTheme.bodyMedium),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryView(title: 'Education')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.more_horiz),
                title: Text('More', style: _textTheme.bodyMedium),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryView(title: 'More')),
                  );
                },
              ),

              
            ],
          ),
        ),
      );
    }
  );

}
