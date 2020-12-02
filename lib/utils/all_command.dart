import 'package:math_expressions/math_expressions.dart';
import 'package:torch/torch.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:url_launcher/url_launcher.dart';

class AllCommand {
  Future<String> getCommand(String cmd) async {
    String command = cmd.toLowerCase();
    if (command == 'hello') {
      return 'hi';
    } else if (command == 'light on' ||
        command == 'turn on the light' ||
        command == 'on the light' ||
        command == 'turn off the light' ||
        command == 'off the light' ||
        command == 'off light' ||
        command == 'light off' || 
        command == 'lights off') {
      bool hasTorch = await Torch.hasTorch;
      if (hasTorch) {
        command == 'light on' ||
                command == 'turn on the light' ||
                command == 'on the light'
            ? Torch.turnOn()
            : Torch.turnOff();
        return 'Completed ✅';
      }
      return 'Phone has no Flashlight';
    } else if (command == 'open whatsapp' ||
        command == 'open twitter' ||
        command == 'open photos') {
      String domain = command == 'open whatsapp'
          ? "com.whatsapp"
          : command == 'open twitter'
              ? "com.twitter.android"
              : "com.google.android.apps.photos";
      AppAvailability.launchApp(domain).then((_) {
        return 'Completed ✅';
      }).catchError((err) {
        return 'App is not available';
      });
      return 'Completed ✅';
    } else {
      if (command.contains('+') ||
          command.contains('*') ||
          command.contains('/') ||
          command.contains('-') ||
          command.contains('^')) {
        return solveMaths(command);
      }
      if (command.contains('search')) {
        return await searchGoogle(command
            .replaceAll(RegExp('search '), '')
            .replaceAll(RegExp(' '), '+'));
      }
      if (command.contains('muchas')) {
        return 'De nada 🤗🤓';
      }
      if (command.contains('how')) {
        return 'Fine, thank you🤗';
      }
      if (command.contains('thank')) {
        return 'You are welcome 🤗';
      }
      if (command.contains('welcome')) {
        return '🤗🤗🤗🤗';
      }
      return 'Sorry, command is unfamilair';
    }
  }

  searchGoogle(command) async {
    String url = 'https://google.com/search?q=$command';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
      return 'Completed ✅';
    } else {
      return 'Could not launch $url';
    }
  }

  solveMaths(command) {
    Parser p = Parser();
    ContextModel cm = ContextModel();
    Expression exp = p.parse(command.trim());
    double result = exp.evaluate(EvaluationType.REAL, cm);
    return 'Result: $result';
  }
}
