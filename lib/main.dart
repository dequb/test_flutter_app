import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'https://www.gm.eurac.edu/limesurvey3/index.php/538477';

// Localization support start

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String> _sentences;

  Future<bool> load() async {
    String data = await rootBundle.loadString('assets/locale/localization_${this.locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }

  String trans(String key) {
    return this._sentences[key];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['de', 'it', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();

    print("Load ${locale.languageCode}");

    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

// Localization support end


// Main
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter WebView Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      supportedLocales: [
        const Locale('de', 'DE'),
        const Locale('it', 'IT'),
        const Locale('en', 'US')
      ],
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        if (locale == null) return Locale('und', 'US'); // FIXME??
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      routes: {
        '/': (_) => const MyHomePage(title: 'Flutter WebView Demo'),
        '/widget': (_) => new WebviewScaffold(
          url: selectedUrl,
          appBar: new AppBar(
            title: const Text('Widget webview'),
          ),
          withZoom: true,
          withLocalStorage: true,
        )
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Instance of WebView plugin
  /*final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onScrollYChanged;
  StreamSubscription<double> _onScrollXChanged;*/
  final _urlCtrl = new TextEditingController(text: selectedUrl);
  //final _codeCtrl =  new TextEditingController(text: 'window.navigator.userAgent');
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  //final _history = [];

  String barcode = "";

  @override
  void initState() {
    super.initState();

    //flutterWebviewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    /*_onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onScrollYChanged =
        flutterWebviewPlugin.onScrollYChanged.listen((double y) {
          if (mounted) {
            setState(() {
              _history.add("Scroll in  Y Direction: $y");
            });
          }
        });

    _onScrollXChanged =
        flutterWebviewPlugin.onScrollXChanged.listen((double x) {
          if (mounted) {
            setState(() {
              _history.add("Scroll in  X Direction: $x");
            });
          }
        });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (mounted) {
            setState(() {
              _history.add('onStateChanged: ${state.type} ${state.url}');
            });
          }
        });

    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
          if (mounted) {
            setState(() {
              _history.add('onHttpError: ${error.code} ${error.url}');
            });
          }
        });*/
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    /*_onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebviewPlugin.dispose();*/

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Example app'),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Container(
            padding: const EdgeInsets.all(24.0),
            //child: new TextField(controller: _urlCtrl),
          ),
          new RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/widget');
            },
            child: const Text('Open questionnaire'),
          ),
          new RaisedButton(
            onPressed: () {
              barcodeScanning();
            },
            child: Text(AppLocalizations.of(context).trans('take_photo'))
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          new Text("Barcode Number after Scan : " + barcode)
          // displayImage(),
        ],
      ),
    );
  }

  Future barcodeScanning() async {

    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
      'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

/* Old function
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Plugin example app'),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Container(
            padding: const EdgeInsets.all(24.0),
            child: new TextField(controller: _urlCtrl),
          ),
          new RaisedButton(
            onPressed: () {
              flutterWebviewPlugin.launch(selectedUrl,
                  rect: new Rect.fromLTWH(
                      0.0, 0.0, MediaQuery.of(context).size.width, 300.0),
                  userAgent: kAndroidUserAgent);
            },
            child: const Text('Open Webview (rect)'),
          ),
          new RaisedButton(
            onPressed: () {
              flutterWebviewPlugin.launch(selectedUrl, hidden: true);
            },
            child: const Text('Open "hidden" Webview'),
          ),
          new RaisedButton(
            onPressed: () {
              flutterWebviewPlugin.launch(selectedUrl);
            },
            child: const Text('Open Fullscreen Webview'),
          ),
          new RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/widget');
            },
            child: const Text('Open widget webview'),
          ),
          new Container(
            padding: const EdgeInsets.all(24.0),
            child: new TextField(controller: _codeCtrl),
          ),
          new RaisedButton(
            onPressed: () {
              final future =
              flutterWebviewPlugin.evalJavascript(_codeCtrl.text);
              future.then((String result) {
                setState(() {
                  _history.add('eval: $result');
                });
              });
            },
            child: const Text('Eval some javascript'),
          ),
          new RaisedButton(
            onPressed: () {
              setState(() {
                _history.clear();
              });
              flutterWebviewPlugin.close();
            },
            child: const Text('Close'),
          ),
          new RaisedButton(
            onPressed: () {
              flutterWebviewPlugin.getCookies().then((m) {
                setState(() {
                  _history.add('cookies: $m');
                });
              });
            },
            child: const Text('Cookies'),
          ),
          new Text(_history.join('\n'))
        ],
      ),
    );
  }*/
}