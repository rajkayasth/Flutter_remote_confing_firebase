import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Remote Config",
    home: FutureBuilder<FirebaseRemoteConfig>(
      future: setupRemoteConfig(),
      builder:
          (BuildContext context, AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
        return snapshot.hasData
            ? Home(remoteConfig: snapshot.requireData)
            : Container(
                child: Text("No data available"),
              );
      },
    ),
  ));
}

class Home extends AnimatedWidget {
  final FirebaseRemoteConfig remoteConfig;

  Home({required this.remoteConfig}) : super(listenable: remoteConfig);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remote Config"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 150.0,
                ),
                Image.network(remoteConfig.getString("Image")),
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    remoteConfig.getString("Text"),
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(remoteConfig.lastFetchStatus.toString()),
                SizedBox(
                  height: 20.0,
                ),
                Text(remoteConfig.lastFetchTime.toString()),
                SizedBox(
                  height: 20.0,
                ),
                FloatingActionButton(
                  onPressed: () async {
                    try {
                      await remoteConfig.setConfigSettings(RemoteConfigSettings(
                          fetchTimeout: Duration(seconds: 10),
                          minimumFetchInterval: Duration.zero));
                      await remoteConfig.fetchAndActivate();
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Icon(Icons.refresh),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.fetch();
  await remoteConfig.activate();

//testing
  print(remoteConfig.getString("Text"));

  return remoteConfig;
}
