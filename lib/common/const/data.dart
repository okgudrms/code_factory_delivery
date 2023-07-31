// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = "ACCES_TOKEN";
const REFRESH_TOKEN_KEY = "REFRESH_TOKEN";
const storage = FlutterSecureStorage();

//local host
const emulatorIP = '10.0.2.2:3000';
const simulatorIP = '127.0.0.1:3000';

final ip = Platform.isIOS ? simulatorIP : emulatorIP;
