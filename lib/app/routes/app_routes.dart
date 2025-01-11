part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const AUTH = _Paths.AUTH;
  static const CHAT = _Paths.CHAT;
  static const CHAT_LIST = _Paths.CHAT_LIST;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const CHAT = '/chat';
  static const CHAT_LIST = '/chat-list';
}
