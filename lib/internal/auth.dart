library pbp_django_auth;

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class Cookie {
  String name;
  String value;
  int? expireTimestamp;

  Cookie(this.name, this.value, this.expireTimestamp);

  Cookie.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        value = json['value'],
        expireTimestamp = json['expireTimestamp'];

  Map toJson() => {
        "name": name,
        "value": value,
        "expireTimestamp": expireTimestamp,
      };
}

class CookieRequest {
  Map<String, String> headers = {};
  Map<String, Cookie> cookies = {};
  Map<String, dynamic> jsonData = {};
  final http.Client _client = http.Client();

  late SharedPreferences local;

  bool loggedIn = false;
  bool initialized = false;

  Future init() async {
    try {
      if (!initialized) {
        local = await SharedPreferences.getInstance();
        cookies = _loadSharedPrefs();
        if (cookies['sessionid'] != null) {
          loggedIn = true;
          headers['cookie'] = _generateCookieHeader();
        }
      }
      initialized = true;
    } catch (e) {
      print('Error during initialization: $e');
      initialized = false;
    }
  }

  Map<String, Cookie> _loadSharedPrefs() {
    try {
      String? savedCookies = local.getString("cookies");
      if (savedCookies == null) {
        return {};
      }

      Map<String, Cookie> convCookies = {};

      var localCookies =
          Map<String, Map<String, dynamic>>.from(json.decode(savedCookies));
      for (String keyName in localCookies.keys) {
        convCookies[keyName] = Cookie.fromJson(localCookies[keyName]!);
      }
      return convCookies;
    } catch (e) {
      print('Error loading shared preferences: $e');
      return {};
    }
  }

  Future persist(String cookies) async {
    try {
      await local.setString("cookies", cookies);
    } catch (e) {
      print('Error persisting cookies: $e');
    }
  }

  Future<dynamic> login(String url, dynamic data) async {
    try {
      await init();
      if (kIsWeb) {
        dynamic c = _client;
        c.withCredentials = true;
      }

      http.Response response =
          await _client.post(Uri.parse(url), body: data, headers: headers);

      await _updateCookie(response);

      if (response.statusCode == 200) {
        loggedIn = true;
        jsonData = json.decode(response.body);
        print('Login successful');
      } else {
        loggedIn = false;
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return json.decode(response.body);
    } catch (e) {
      print('Error during login: $e');
      return {'status': false, 'message': 'Error during login: $e'};
    }
  }

  Map<String, dynamic> getJsonData() {
    return jsonData;
  }

  Future<dynamic> get(String url) async {
    try {
      await init();
      if (kIsWeb) {
        dynamic c = _client;
        c.withCredentials = true;
      }

      http.Response response = await _client.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode != 200) {
        print('GET request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      await _updateCookie(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error during GET request: $e');
      return {'status': false, 'message': 'Error during GET request: $e'};
    }
  }

  Future<dynamic> post(String url, dynamic data) async {
    try {
      await init();
      if (kIsWeb) {
        dynamic c = _client;
        c.withCredentials = true;
      }

      http.Response response =
          await _client.post(Uri.parse(url), body: data, headers: headers);
      
      if (response.statusCode != 200) {
        print('POST request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      await _updateCookie(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error during POST request: $e');
      return {'status': false, 'message': 'Error during POST request: $e'};
    }
  }

  Future<dynamic> postJson(String url, dynamic data) async {
    try {
      await init();
      if (kIsWeb) {
        dynamic c = _client;
        c.withCredentials = true;
      }

      headers['Content-Type'] = 'application/json; charset=UTF-8';
      http.Response response =
          await _client.post(Uri.parse(url), body: data, headers: headers);

      if (response.statusCode != 200) {
        print('POST JSON request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      headers.remove('Content-Type');
      await _updateCookie(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error during POST JSON request: $e');
      return {'status': false, 'message': 'Error during POST JSON request: $e'};
    }
  }

  Future _updateCookie(http.Response response) async {
    try {
      await init();
      String? allSetCookie = response.headers['set-cookie'];

      if (allSetCookie != null) {
        allSetCookie = allSetCookie.replaceAll(
          RegExp(r'expires=.+?;', caseSensitive: false),
          "",
        );
        var setCookies = allSetCookie.split(',');

        for (var cookie in setCookies) {
          _setCookie(cookie);
        }

        headers['cookie'] = _generateCookieHeader();
        String cookieObject = (const JsonEncoder()).convert(cookies);
        await persist(cookieObject);
      }
    } catch (e) {
      print('Error updating cookies: $e');
    }
  }

  void _setCookie(String rawCookie) {
    try {
      if (rawCookie.isEmpty) {
        return;
      }

      var cookieProps = rawCookie.split(";");

      var keyValue = cookieProps[0].split('=');
      if (keyValue.length != 2) {
        print('Invalid cookie format');
        return;
      }

      String cookieName = keyValue[0].trim();
      String cookieValue = keyValue[1];

      int? cookieExpire;
      for (var props in cookieProps.sublist(1)) {
        var keyval = props.split("=");
        if (keyval.length != 2) {
          continue;
        }

        var key = keyval[0].trim().toLowerCase();
        if (key != 'max-age') {
          continue;
        }

        int? deltaTime = int.tryParse(keyval[1]);
        if (deltaTime != null) {
          cookieExpire = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          cookieExpire += deltaTime;
        }
        break;
      }
      cookies[cookieName] = Cookie(cookieValue, cookieValue, cookieExpire);
    } catch (e) {
      print('Error setting cookie: $e');
    }
  }

  String _generateCookieHeader() {
    try {
      int currTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String cookie = "";

      for (var key in cookies.keys) {
        if (cookie.isNotEmpty) cookie += ";";
        Cookie? curr = cookies[key];

        if (curr == null) continue;
        if (curr.expireTimestamp != null && currTime >= curr.expireTimestamp!) {
          if (curr.name == "sessionid") {
            print('Session expired');
            loggedIn = false;
            jsonData = {};
            cookies = {};
          }
          continue;
        }

        String newCookie = curr.value;
        cookie += '$key=$newCookie';
      }

      return cookie;
    } catch (e) {
      print('Error generating cookie header: $e');
      return "";
    }
  }

  Future<dynamic> logout(String url) async {
    try {
      await init();
      if (kIsWeb) {
        dynamic c = _client;
        c.withCredentials = true;
      }

      http.Response response =
          await _client.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        loggedIn = false;
        jsonData = {};
        print('Logout successful');
      } else {
        loggedIn = true;
        print('Logout failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      cookies = {};
      return json.decode(response.body);
    } catch (e) {
      print('Error during logout: $e');
      return {'status': false, 'message': 'Error during logout: $e'};
    }
  }
}