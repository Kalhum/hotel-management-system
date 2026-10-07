import 'package:envied/envied.dart';
// import 'package:firebase_core/firebase_core.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(
    varName: 'WEB_API_KEY',
    obfuscate: true,
  )
  static final String webApiKey = _Env.webApiKey;

  @EnviedField(
    varName: 'WEB_API_ID',
    obfuscate: true,
  )
  static final String webApiId = _Env.webApiId;


  @EnviedField(
    varName: 'IOS_MACOS_API_KEY',
    obfuscate: true,
  )
  static final String iosApiKey = _Env.iosApiKey;


    @EnviedField(
    varName: 'IOS_MACOS_API_ID',
    obfuscate: true,
  )
  static final String iosApiId = _Env.iosApiId;

  @EnviedField(
    varName: 'WINDOW_API_KEY',
    obfuscate: true,
  )
  static final String windowsApiKey = _Env.windowsApiKey;


    @EnviedField(
    varName: 'WINDOW_API_ID',
    obfuscate: true,
  )
  static final String windowsApiId = _Env.windowsApiId;


  @EnviedField(
    varName: 'PROJECT_ID',
    obfuscate: true,
  )
  static final String projectId = _Env.projectId;

}
