import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
            "The email address is already in use by another account.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}

enum MessageType {
  text,
  image,
}

class MessageEnum {
  // static String getMessageType(MessageType messageType) {
  //   String type;
  //   switch (messageType) {
  //     case MessageType.text:
  //       type = "text";
  //       break;
  //     case MessageType.image:
  //       type = "image";
  //       break;
  //     default:
  //       type = "text";
  //   }
  //   return type;
  // }

  static MessageType getMessageTypeEnum(String messageType) {
    MessageType type;
    switch (messageType) {
      case "text":
        type = MessageType.text;
        break;
      case "image":
        type = MessageType.image;
        break;
      default:
        type = MessageType.text;
    }
    return type;
  }
}
