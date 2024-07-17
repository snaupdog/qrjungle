import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height*0),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(15),
              ),
              height: MediaQuery.sizeOf(context).height*0.2,
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 8, 0, 10),
                      child: Column(                    
                        children: [                      
                          Text('Want your customisation on our QRs?', style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 24, fontWeight: FontWeight.w600)),                      
                          SizedBox(height: 10),
                          Text('Tell us what you need, we\'ll make it happen!', style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 16)),                      
                        ]
                      ),
                    ),
                  ),
                  Expanded(child: Image.asset('assets/qrsqrs.png', height: 160))
                ],
              ),
            ),
            Container(
              height: MediaQuery.sizeOf(context).height*0.23,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Swiper(
                itemCount: 5,
                itemBuilder: (BuildContext context,int index){
                  return Image.asset('assets/logo.png', fit: BoxFit.contain, height: 20,);
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}