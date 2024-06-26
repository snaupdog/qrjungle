import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrjungle/models/apis_rest.dart';
import 'package:qrjungle/models/apis_signup.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/moreqr/widgets/modals.dart';
import 'package:qrjungle/pages/otpcheck.dart';
import '../../models/qr_info.dart';
import '../moreqr/moreqr.dart';

class QrCards extends StatefulWidget {
  final bool catagories;
  final String categoryName;
  const QrCards(
      {super.key, required this.catagories, required this.categoryName});

  @override
  QrCardsState createState() => QrCardsState();
}

class QrCardsState extends State<QrCards> {
  List<QrInfo> qrobjects = []; // Declare qrobjects here
  List<String> urls = [];
  String token = '';

  @override
  void initState() {
    super.initState();
    if (!widget.catagories) {
      fetchAllQrs();
    } else {
      fetchCategorieQrs(widget.categoryName);
    }
  }

  Future<void> fetchCategorieQrs(String categoryname) async {
    try {
      qrobjects = await ApissRest().getqrfromCategories(categoryname);
      final fetchedUrls = await Future.wait(qrobjects
          .map((key) => ApissRest().getPresignedUrl(key.UrlKey))
          .toList());
      setState(() {
        urls = fetchedUrls;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> signInCustomFlow(String username) async {
    print('email is: $username');
    await Amplify.Auth.signOut();
    // ignore: unused_local_variable
    final num = "${emailController.text}";
    try {
      final result = await Amplify.Auth.signIn(username: username);
      print('Result@@@@@@@@@@@!!!!!!: $result');
      return 'Success';
    } on AuthException catch (e) {
      print("error");
      print("message: ${e.message}");
      if (e.message.contains('No password was provided')) {
        await ApissSignup().signup(emailController.text);
      }
      return e.message;
    }
  }

  Future<void> fetchAllQrs() async {
    try {
      qrobjects = await ApissRest().getAllqrs(token);
      final fetchedUrls = await Future.wait(qrobjects
          .map((key) => ApissRest().getPresignedUrl(key.UrlKey))
          .toList());
      setState(() {
        urls = fetchedUrls;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    TextTheme textTheme = Theme.of(context).textTheme;
    Color colorcolor = brightness == Brightness.dark
        ? const Color(0xff1B1B1B)
        : const Color.fromARGB(255, 247, 249, 254);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 7.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 2 / 3),
        itemCount: urls.length,
        itemBuilder: (context, index) {
          final imageUrl = urls[index];
          final item = qrobjects[index];
          return GestureDetector(
            onTap: () {
              if (!loggedinmain) {
                LogInModalSheet(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MoreQr(imageUrl: imageUrl, qrinfo: item)),
                );
              }
            },
            child: Container(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Card(
                  color: colorcolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                            child: Text(item.qr_code_id,
                                style: textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child:
                                Text(item.category, style: textTheme.bodySmall),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void LogInModalSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return LoginModalSheet(
          emailController: emailController,
          signInCustomFlow: signInCustomFlow,
          onSuccess: () {
            Fluttertoast.showToast(
                          msg: "Logged In!",
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color.fromARGB(134, 0, 0, 0),
                          textColor: Colors.white,
                          fontSize: 18.0
                      );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerify(email: emailController.text),
              ),
            );
          },
        );
      },
    );
  }
}
