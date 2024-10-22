import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeetingScreen extends StatefulWidget {
  final String appId =
      '841f6090e35844b1860e232bdbf4b325'; // Replace with your Agora App ID
  final String appCertificate =
      '72f8f49b581f41b4a4fefa998beb484a';

  const MeetingScreen({super.key}); // Replace with your Agora App Certificate

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  String channelName = 'room1';
  String token = '';
  int tokenRole = 1; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience
  String serverUrl =
      "https://tokengenerator.onrender.com"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  int tokenExpireTime = 45; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire
  final channelTextController = TextEditingController(text: '');

  Future<String> generateToken() async {
    // final url = Uri.parse('https://agora-token-service-production-2d6b.up.railway.app/');
    String uid = '';

    // Prepare the Url
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${tokenExpireTime.toString()}';

    // Send the request
    final  response = await http.get(Uri.parse(url), headers: {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          'true', // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "GET, OPTIONS"
    });
    if (response.statusCode == 200) {
      token = response.body;
      return token;
    } else {
      throw Exception('Failed to generate Agora token');
    }
  }

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${tokenExpireTime.toString()}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      // setToken(newToken);
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  Future<void> createChannel() async {
    // Implement your channel creation logic here
    // You can use the Agora SDK or any backend services of your choice to create a channel
    // This example assumes you have a backend API to handle the channel creation
    // You can make an API call to your backend to create a channel and store it in a database
    // Retrieve the generated channel name and set it to the 'channelName' variable

    // For example:
    // String apiUrl = 'https://your-backend-api.com/create-channel';
    // final response = await http.post(apiUrl);
    // if (response.statusCode == 200) {
    //   Map<String, dynamic> data = json.decode(response.body);
    //   channelName = data['channelName'];
    // } else {
    //   throw Exception('Failed to create channel: ${response.statusCode}');
    // }
  }

  @override
  void initState() {
    super.initState();
    // fetchToken(1, channelName, tokenRole);
    createChannel().then((_) {
      generateToken().then((token) {
        setState(() {
          this.token = token;
          print(token);
        });
      }).catchError((error) {
        print('Failed to generate token: $error');
      });
    }).catchError((error) {
      print('Failed to create channel: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Token: $token',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Channel Name: $channelName',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
