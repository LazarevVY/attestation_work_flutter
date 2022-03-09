import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthData {
  String phone = "";
  String pass  = "";

  AuthData ( { required this.phone, required this.pass } );

  bool eq ( AuthData data ) => ( pass == data.pass && phone == data.phone );
}

class UI extends MaterialApp {

  // final containerDecoration = const BoxDecoration(
  //     image: DecorationImage(
  //       image : AssetImage("assets/images/bg1.jpeg"),
  //       fit   : BoxFit.cover,
  //     ));

  // final logo = const SizedBox(
  //     width   : 110,
  //     height  : 84,
  //     child   : Image(image: AssetImage("assets/images/dart-logo-bird.png",
  //     )));

  static const borderStyle =  OutlineInputBorder(
      borderRadius : BorderRadius.all(Radius.circular(36)),
      borderSide   : BorderSide(
          color    : Color(0xffeceff1),
          width    : 5
      ));

  static const linkTextStyle = TextStyle(
      fontSize     : 16,
      color        : Color(0xFF0079D0)
  );

  static var bnLoginStyle = ElevatedButton.styleFrom(
      primary : const Color(0xFF0079D0),
      shape   : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0)
      ));
}

// Простое форматирование ввода телефонного номера российского оператора связи. //
// Код +7 не вводится, учитываются только цифры самого номера                   //

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newValueText = newValue.text.replaceAll(RegExp("[^0-9]"), "");
    int lastSelectionOffset = newValue.selection.end;
    return TextEditingValue(
        text: newValueText,
        selection: TextSelection.collapsed(offset: lastSelectionOffset )
    );
  }
}

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  AuthData definedLogin           = AuthData(phone: "9992223344", pass: "P@s\$w0rd");
  static const int maxPhoneLength = 10;
  static const int maxPassLength  = 10;
  static const String badLogin    = "Пользователь не существует\nили неверно введен пароль.";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _enteredLogin = AuthData(phone: "", pass: "");
  late var _badLogin     = "";
  void _phoneOnChanged (String val){
    setState(() {
      _enteredLogin.phone = val;
    });
  }

  void _passOnChanged (String val){
    setState(() {
      _enteredLogin.pass = val;
    });
  }

    Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка аутентификации'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Телефон или пароль пользователя не найдены.'),
                SizedBox(height: 20,),
                Text('Повторите ввод!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Назад'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _login () {
    if (_enteredLogin.eq(widget.definedLogin)) {
      Navigator.of(context).pushNamedAndRemoveUntil("/main", (route) => false);
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
            //decoration : UI().containerDecoration,
            width      : double.infinity,
            height     : double.infinity,
            padding    : const EdgeInsets.symmetric(horizontal: 50),
            child      : SingleChildScrollView(
              child: Column (
                children: [
                  const SizedBox(height: 150,),
                  //UI().logo,
                  const SizedBox(height: 20,),
                  const Text("Введите логин в виде ${AuthScreen.maxPhoneLength} цифр номера телефона",
                    style: TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.6)),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                      maxLength       : AuthScreen.maxPhoneLength,
                      textDirection   : TextDirection.ltr,
                      inputFormatters : [ PhoneFormatter() ],
                      keyboardType    : TextInputType.phone,
                      onChanged       : _phoneOnChanged,
                      decoration      : const InputDecoration(
                        labelText     : "Телефон",
                        filled        : true,
                        fillColor     : Color(0xFFECEFF1),
                        enabledBorder : UI.borderStyle,
                        focusedBorder : UI.borderStyle,
                      )),
                  const SizedBox(height: 20,),
                  TextField(
                      maxLength       : AuthScreen.maxPassLength,
                      textDirection   : TextDirection.ltr,
                      obscureText     : true,
                      onChanged       : _passOnChanged,
                      decoration      : const InputDecoration(
                        labelText     : "Пароль",
                        filled        : true,
                        fillColor     : Color(0xFFECEFF1),
                        enabledBorder : UI.borderStyle,
                        focusedBorder : UI.borderStyle,
                      )),
                  //Text('${_enteredLogin.phone}/${_enteredLogin.pass}'), // вывод для отладки
                  const SizedBox(height: 28,),
                  SizedBox(
                      width  : 154,
                      height : 42,
                      child  : ElevatedButton(
                        child  : const Text("Войти"),
                        style : UI.bnLoginStyle,
                        onPressed : (){_login ();},
                      )),
                  const SizedBox(height: 62,),
                  InkWell(
                    child: const Text("Забыли пароль?", style: UI.linkTextStyle),
                    onTap: () {

                    },),
                  const SizedBox(height: 32,),
                  Text ("${_badLogin}", style: TextStyle(color: Colors.red, fontSize: 18),),
                ],
              ),
            ),
          )
      ),
    );
  }
}