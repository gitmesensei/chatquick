import 'package:chatquick/onboardingcomp/otp.dart';
import 'package:chatquick/models/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';


class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String code;
  String verificationId;
  String phone;
  Country _selected=Country.IN;
  Image myImage;


  double _fixedPadding;
  TextEditingController controller;



  Future<void> verify() async{
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String id){
      this.verificationId=id;
    };
    final PhoneCodeSent codeSent = (String id,[int resend]){
      this.verificationId=id;
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OTP(verificationId,_selected.dialingCode+phone)));
    };

    final PhoneVerificationCompleted completed = (user){

    };
    final PhoneVerificationFailed failed = (FirebaseAuthException exception){
      print('${exception.message}');
    };


    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phone,
        timeout: const Duration(seconds: 5),
        verificationCompleted:completed,
        verificationFailed: failed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _fixedPadding = 20;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.pink.shade200,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: SizeConfig.safeBlockHorizontal*100,
                  height: SizeConfig.safeBlockVertical*30,
                  color: Colors.black,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50,bottom: 0,left: 20),
                        child: Center(
                          child: Row(
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                                  child: Text(
                                    'ChatQuick',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black45,
                                            blurRadius: 2,
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



                //  Subtitle for Enter your phone
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.0, left: 30,bottom: 20),
                    child: Text('Enter your phone number',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                ),
                //  PhoneNumber TextFormFields
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: EdgeInsets.only(left: 10,top: 0),
                        child: new Center(
                          child: CountryPicker(
                            dense: false,
                            showFlag: true,  //displays flag, true by default
                            showDialingCode: true, //displays dialing code, false by default
                            showName: true, //displays country name, true by default
                            showCurrency: false, //eg. 'British pound'
                            showCurrencyISO:false, //eg. 'GBP'
                            onChanged: (Country country) {
                              setState(() {
                                _selected = country;
                              });
                            },
                            selectedCountry: _selected,
                          ),
                        ),
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal*58,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 0,
                              right: 0,),
                          child: Card(
                            child: TextFormField(
                              controller:controller,
                              keyboardType: TextInputType.phone,
                              key: Key('EnterPhone-TextFormField'),
                              maxLengthEnforced: true,
                              maxLength: 10,
                              style: TextStyle(fontSize: 18,letterSpacing: 4,fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                counterStyle: TextStyle(height: double.minPositive,),
                                counterText: "",
                                contentPadding: EdgeInsets.only(left: 10),
                                border: InputBorder.none,
                                errorMaxLines: 1,
                              ),
                              onChanged: (value){

                                phone="+"+_selected.dialingCode+value;

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(width: _fixedPadding),
                      Icon(Icons.info, color: Colors.red, size: 20.0),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'We will send ',
                                  style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)),
                              TextSpan(
                                  text: 'One Time Password',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,color: Colors.black)),
                              TextSpan(
                                  text: ' to this mobile number',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,color: Colors.black)),
                            ])),
                      ),
                      SizedBox(width: _fixedPadding),
                    ],
                  ),
                ),
                SizedBox(height: _fixedPadding * 1.5),
                Container(
                  child: ButtonTheme(
                    minWidth: 40,
                    child: RaisedButton(
                      elevation: 5.0,
                      splashColor: Colors.white,
                      onPressed: verify,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
                )
    );
  }

}
