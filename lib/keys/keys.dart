import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

const String FLWPUBKEY = 'FLWPUBK_TEST-5440b97b8cee96f460db958b2e1064be-X';
const String FLWSECKEY = 'FLWSECK_TEST-be48b0eec2eb79080f320dd6480b1f92-X';
const String PayStackKey = 'pk_test_52197b2afc4c27f4491282296d1a848bea6794f9';
const String fcmKey =
    'AAAAyIDkiIA:APA91bEFOwM4UIaZcfHJC1zGDdMIr1WO38dr7Fr5FMR9NM_yJiakBCsU-CTjGbnDxpJXyESM0qM8Mqul2Y1O6UeP2m44BjRjRMV_DW5jp3fHNQyHp80mtZqosRdJqJcGigShOocBRFrO';
    

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) {
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ),
  );
}

String formatDate(Timestamp timestamp) {
  return DateFormat('dd-MM-yy').format(timestamp.toDate());
}

String formatTime(Timestamp timestamp) {
  return DateFormat.yMEd().add_jms().format(timestamp.toDate());
}

String time(Timestamp timestamp) {
  return DateFormat.jm().format(timestamp.toDate());
}
