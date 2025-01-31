import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionCheck {
  final InternetConnection internetConnection;
  ConnectionCheck(this.internetConnection);

  Future<bool> get isConnected async {
    return await internetConnection.hasInternetAccess;
  }
}
