
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:ticketglass_mobile/src/services/auth_service.dart';
// import 'dart:ui' as ui show Image;

import 'package:ticketglass_mobile/src/widgets/buttons.dart';
import 'package:ticketglass_mobile/src/widgets/progress_indicator.dart';
    Logger logger =  Logger();

class Login extends StatefulWidget {
  const  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late PageController pageController;

  final TextEditingController phoneController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'QA');
  final _formKey = GlobalKey<FormState>();

  String? verificationId  ;


  void getPhoneNumber(PhoneNumber phoneNumber) async {
    final String phone = phoneNumber.phoneNumber.toString();

    try{
    customProgressIdicator(context);
      logger.d('verifying phone number');
      await FirebaseAuth.instance.verifyPhoneNumber(
  phoneNumber: phone, //'+97412345678',
  verificationCompleted: (PhoneAuthCredential credential) async {
    logger.d('verificationCompleted');

    if (Platform.isAndroid) {
// / ANDROID ONLY!
    // Sign the user in (or link) with the auto-generated credential
    await FirebaseAuth.instance.signInWithCredential(credential);
    } 
    // TODO: confirm the credential on iOS
  },
  verificationFailed: (FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    }
    logger.w( 'verificationFailed',  e);
    
    // Handle other errors
  },

  codeSent: (String verificationId, int? resendToken) async {
    // Update the UI - wait for the user to enter the SMS code
    this.verificationId = verificationId;

    logger.d('codeSent');
  
    Navigator.pop(context);
   // go to otp page
    next();
   
    
  },
  timeout: const Duration(seconds: 60),
  codeAutoRetrievalTimeout: (String verificationId) {

      logger.d(' auto retrival timedout');
    // Auto-resolution timed out...
  },
);
    } on FirebaseAuthException catch (e) {
      print('error message');
      print(e.message); // return the error message can be used to give feedback to the user
      logger.d(e.message);
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
        pageController.dispose();

    super.dispose();
  }


next() {
  setState(() {
    
    pageController.nextPage(
        duration: Duration(milliseconds: 600), curve: Curves.easeInOutExpo);
  });
  }

@override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, keepPage: true);
    // _auth = context.read(authServicesProvider);
    // TODO: add toasts
    // fToast = FToast();
    // fToast.init(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).copyWith().size.height,
                width: MediaQuery.of(context).copyWith().size.width,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Container(
                        height: MediaQuery.of(context).copyWith().size.height * 0.8,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                      'Ticketglass',
                      style: TextStyle(
                          fontFamily: 'FORTE',
                          fontSize: 35,
                          ),
                    ),
                     SizedBox(height: 20),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 25,
                          ),
                    ),
                    Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    // set container border radius 10
                    decoration: BoxDecoration(
                    color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                        BoxShadow(
                          color:
                                Colors.black
                                  .withOpacity(
                                      0.1),
                          spreadRadius: 0.5,
                          blurRadius: 1,
                          offset: Offset(0,
                              2), // changes position of shadow
                        ),
                        ]
                    ),
                    child: InternationalPhoneNumberInput(
                        
                                    scrollPadding: EdgeInsets.only(bottom:  150),
              onInputChanged: (PhoneNumber number) {
                // print(number.phoneNumber,);
              },
              onInputValidated: (bool value) {
                // print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: phoneController,
              formatInput: false,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                    getPhoneNumber(number);
                // print('On Saved: $number');
                // formKey.currentState.save()
              },
            ),
            ),
                              
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ButtonWidget(
                                      context: context,
                                      text: 'Login',
                                      onPressed: () {
                                        if ( _formKey.currentState != null ) {
                                          if (_formKey.currentState!.validate()) {
                                          _formKey.currentState?.save();
                                          }
                                        }
                                      }),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                if (FocusScope.of(context).hasFocus)
                                  SizedBox(
                                    height: 20,
                                  ),
                              ],
                            ),
                          OtpPage(verificationId: this.verificationId),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}  

class OtpPage extends StatefulWidget {
  final String? verificationId;
  const OtpPage({required this.verificationId, Key? key}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

  late TextEditingController otpController ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    otpController = TextEditingController();

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter OTP',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(
            height: 20,
          ),
          PinCodeTextField(
          appContext: context,
          keyboardType: TextInputType.number,
          
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(5),
      fieldHeight: 50,
      fieldWidth: 40,
      selectedColor: Colors.blueGrey[800],
      selectedFillColor: Colors.white,
      inactiveFillColor: Colors.white,
      activeFillColor: Colors.white,
      inactiveColor: Colors.grey,
      ),
      animationDuration: Duration(milliseconds: 300),
      enableActiveFill: true,
      controller: otpController,
      onCompleted: (value) async{
    
      if (value.isNotEmpty && widget.verificationId != null) {
        customProgressIdicator(context);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: value);
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pop(context);
      
      }
    
      },
      onChanged: (value) {
      print(value);
      // setState(() {
      //   currentText = value;
      // });
      },
      beforeTextPaste: (text) {
      print("Allowing to paste $text");
      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
      //but you can show anything you want here, like your pop up saying wrong paste format or etc
      return true;
      },
    ),
    
        ],
      ),
    );
    
  }
}