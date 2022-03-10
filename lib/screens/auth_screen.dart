import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthData {
  String phone = "";
  String pass  = "";

  AuthData ( { required this.phone, required this.pass } );

  bool eq ( AuthData data ) => ( pass == data.pass && phone == data.phone );
}

class UI extends MaterialApp { ///// в классе хранятся "тяжелые" настройки ///////
  static const containerDecoration = BoxDecoration (
      image: DecorationImage (
        image : AssetImage ( "assets/images/bg.jpg" ),
        fit   : BoxFit.cover,
        opacity: 0.7,
      )
  );

  // final logo = const SizedBox(
  //     width   : 110,
  //     height  : 84,
  //     child   : Image(image: AssetImage("assets/images/dart-logo-bird.png",
  //     )));

  static const borderStyle =  OutlineInputBorder (
      borderRadius : BorderRadius.zero,    //BorderRadius.all(Radius.circular(36)),
      borderSide   : BorderSide (
          color    : Color ( 0xffeceff1 ),
          width    : 5
      )
  );

  static const linkTextStyle = TextStyle (
      fontSize     : 16,
      color        : Color ( 0xFF0079D0 )
  );

  static var bnLoginStyle = ElevatedButton.styleFrom (
      primary : const Color ( 0xFF0079D0 ),
      shape   : const RoundedRectangleBorder (
          borderRadius: BorderRadius.zero    //BorderRadius.circular(36.0)
      )
  );
}

//////////////////////////////////////////////////////////////////////////////////
// Простое форматирование ввода телефонного номера российского оператора связи. //
// Код +7 не вводится, учитываются только цифры самого номера                   //
//////////////////////////////////////////////////////////////////////////////////
class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate ( TextEditingValue oldValue, TextEditingValue newValue ) {
    String newValueText = newValue.text.replaceAll ( RegExp ( "[^0-9]" ), "" );
    int lastSelectionOffset = newValue.selection.end;
    return TextEditingValue (
        text: newValueText,
        selection: TextSelection.collapsed ( offset: lastSelectionOffset )
    );
  }
}

class AuthScreen extends StatefulWidget {
  AuthScreen ( { Key? key } ) : super ( key: key );

  final  AuthData  definedLogin   = AuthData ( phone: "9992223344", pass: "P@s\$w0rd" );
  static const int maxPhoneLength = 10;
  static const int maxPassLength  = 10;

  @override
  _AuthScreenState createState () => _AuthScreenState ();
}

class _AuthScreenState extends State<AuthScreen> {
  final _enteredLogin = AuthData ( phone: "", pass: "" );

  void _phoneOnChanged ( String val ) {
    setState ( () { _enteredLogin.phone = val; } );
  }

  void _passOnChanged ( String val ) {
    setState ( () {  _enteredLogin.pass = val; } );
  }
  Future<void> _showErrorDialog () async {
    return showDialog <void> (
      context:            context,
      barrierDismissible: false,
      builder:            ( BuildContext context ) {
        return AlertDialog (
          title:   const Text ( "Ошибка аутентификации" ),
          content: SingleChildScrollView (
            child: ListBody (
              children: const <Widget> [
                Text ( "Телефон или пароль пользователя не найдены." ),
                SizedBox ( height: 20 ),
                Text ( "Повторите ввод!" ),
              ]
            )
          ),
          actions: <Widget> [
            TextButton (
              child: const Text ( "Назад" ),
              onPressed: () {
                Navigator.of( context ).pop ();
              }
            )
          ]
        );
      }
    );
  }

  void _login () {
    if ( _enteredLogin.eq ( widget.definedLogin ) ) {
      Navigator.of( context ).pushNamedAndRemoveUntil( "/main", ( route ) => false );
    } else {
      _showErrorDialog ();
    }
  }

  @override
  Widget build ( BuildContext context ) {
    return MaterialApp (
      debugShowCheckedModeBanner: false,
      home: Scaffold (
          body: Container (
            decoration : UI.containerDecoration,
            width      : double.infinity,
            height     : double.infinity,
            padding    : const EdgeInsets.symmetric ( horizontal: 50 ),
            child      : SingleChildScrollView (
              child: Column (
                children: [
                  const SizedBox ( height: 150 ),
                  //UI().logo,
                  const SizedBox ( height: 20 ),
                  const Text ( "Введите логин в виде ${ AuthScreen.maxPhoneLength } цифр номера телефона",
                    style: TextStyle ( fontSize: 18, color: Color.fromRGBO ( 0, 0, 0, 0.6 ) ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox ( height: 20 ),
                  TextField (
                      maxLength       : AuthScreen.maxPhoneLength,
                      textDirection   : TextDirection.ltr,
                      inputFormatters : [ PhoneFormatter () ],
                      keyboardType    : TextInputType.phone,
                      onChanged       : _phoneOnChanged,
                      decoration      : const InputDecoration (
                        labelText     : "Телефон",
                        filled        : true,
                        fillColor     : Color ( 0xffeceff1 ),
                        enabledBorder : UI.borderStyle,
                        focusedBorder : UI.borderStyle,
                      )
                  ),
                  const SizedBox ( height: 20 ),
                  TextField (
                      maxLength       : AuthScreen.maxPassLength,
                      textDirection   : TextDirection.ltr,
                      obscureText     : true,
                      onChanged       : _passOnChanged,
                      decoration      : const InputDecoration (
                        labelText     : "Пароль",
                        filled        : true,
                        fillColor     : Color ( 0xffeceff1 ),
                        enabledBorder : UI.borderStyle,
                        focusedBorder : UI.borderStyle,
                      )
                  ),
                  //Text ( '${ _enteredLogin.phone } / ${ _enteredLogin.pass }'), // вывод пароля для отладки
                  const SizedBox ( height: 56 ),
                  SizedBox (
                      width  : 220,
                      height : 52,
                      child  : ElevatedButton (
                        child  : const Text ( "Войти",
                          style: TextStyle  ( fontSize: 18, color: Color.fromRGBO ( 255, 255, 255, 1.0 ) ) ),
                        style : UI.bnLoginStyle,
                        onPressed : () { _login (); },
                      )
                  )
                ]
              )
            )
          )
      )
    );
  }
}