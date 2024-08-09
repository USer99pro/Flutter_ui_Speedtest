
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'speed_test_result.dart';
import 'history_page.dart';

class SpeedTestUi extends StatefulWidget {
  const SpeedTestUi({super.key});

  @override
  State<SpeedTestUi> createState() => _SpeedTestUiState();
}

class _SpeedTestUiState extends State<SpeedTestUi> {
  double displayProgress = 0.0;
  double _downloadRate = 0.0;
  double _uploadRate = 0.0;
  double displayrate = 0.0;
  bool isServerSelectionInProcess = false;
  String? _ip;
  String? _asn;
  String? _isp;
  bool istestingStarted = false;
  String UnitText = '';
  final speedTest = FlutterInternetSpeedTest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 35, 73),
      appBar: AppBar(
        title: const Text("Speed Test"),
        backgroundColor: const Color.fromARGB(255, 91, 140, 214),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Column(children: [
        const Text(
          "Process",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        LinearPercentIndicator(
          percent: displayProgress / 100.00,
          progressColor: Colors.orange,
          lineHeight: 18,
          center: Text(
            displayProgress.toStringAsFixed(1) + "%",
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          barRadius: const Radius.circular(10),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Downloads : ${_downloadRate.toStringAsFixed(2)} ${UnitText}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Uploads : ${_uploadRate.toStringAsFixed(2)} ${UnitText}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SfRadialGauge(
          axes: [
            RadialAxis(
              radiusFactor: 0.85,
              minorTicksPerInterval: 1,
              tickOffset: 3,
              useRangeColorForAxis: true,
              interval: 4,
              minimum: 0,
              maximum: 25,
              axisLabelStyle: const GaugeTextStyle(
                color: Colors.white,
              ),
              ranges: [
                GaugeRange(
                  color: const Color.fromARGB(255, 30, 244, 255),
                  startValue: 0,
                  endValue: 24,
                  startWidth: 5,
                  endWidth: 10,
                )
              ],
              pointers: [
                NeedlePointer(
                  value: displayrate,
                  enableAnimation: true,
                  needleColor: Colors.orange,
                  tailStyle: const TailStyle(
                      color: Colors.white,
                      borderWidth: 0.1,
                      borderColor: Colors.blue),
                  knobStyle: const KnobStyle(
                    color: Colors.white,
                    borderColor: Colors.red,
                    borderWidth: 0.01,
                  ),
                ),
              ],
              annotations: [
                GaugeAnnotation(
                  widget: Container(
                    child: Text(
                      displayrate.toStringAsFixed(2) + UnitText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  angle: 90,
                  positionFactor: 0.6,
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10),
        Text(
          isServerSelectionInProcess
              ? "Server Selection In Progress..."
              : 'IP ${_ip ?? '__'} | ASN:${_asn ?? '__'} | ISP:${_isp ?? '__'}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 23, 243, 255)),
          onPressed: () {
            testingFunction();
          },
          child: const Text(
            'Start Testing',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> testingFunction() async {
    resetValue();

    await speedTest.startTesting(
      onStarted: () {
        setState(() {
          istestingStarted = true;
        });
      },
      onCompleted: (TestResult download, TestResult upload) async {
        setState(() {
          UnitText = download.unit == SpeedUnit.kbps ? 'kb/s' : 'Mb/s';
          _downloadRate = download.transferRate;
          displayProgress = 100.0;
          displayrate = _downloadRate;
        });
        setState(() {
          UnitText = upload.unit == SpeedUnit.kbps ? 'kb/s' : 'Mb/s';
          _uploadRate = upload.transferRate;
          displayProgress = 100.0;
          displayrate = _uploadRate;
          istestingStarted = false;
        });

        // Save the results to local storage
        await saveResult(SpeedTestResult(
          downloadRate: _downloadRate,
          uploadRate: _uploadRate,
          downloadUnit: download.unit == SpeedUnit.kbps ? 'kb/s' : 'Mb/s',
          uploadUnit: upload.unit == SpeedUnit.kbps ? 'kb/s' : 'Mb/s',
          timestamp: DateTime.now(),
        ));
      },
      onProgress: (double percent, TestResult data) {
        setState(() {
          UnitText = data.unit == SpeedUnit.kbps ? 'kb/s' : 'Mb/s';
          if (data.type == TestType.download) {
            _downloadRate = data.transferRate;
            displayrate = _downloadRate;
            displayProgress = percent;
          } else {
            _uploadRate = data.transferRate;
            displayrate = _uploadRate;
            displayProgress = percent;
          }
        });
      },
      onError: (String errorMessage, String speedTestError) {
        print("error: " + errorMessage + speedTestError);
      },
      onDefaultServerSelectionInProgress: () {
        setState(() {
          isServerSelectionInProcess = true;
        });
        // Only when you use useFastApi parameter as true(default)
      },
      onDefaultServerSelectionDone: (Client? client) {
        setState(() {
          isServerSelectionInProcess = false;
          _ip = client!.ip;
          _asn = client.asn;
          _isp = client.isp;
        });
        // Only when you use useFastApi parameter as true(default)
      },
      onDownloadComplete: (TestResult data) {
        setState(() {
          UnitText = data.unit == SpeedUnit.kbps ? 'kb/s' : 'Mb/s';
          _downloadRate = data.transferRate;
          displayrate = _downloadRate;
        });
      },
      onUploadComplete: (TestResult data) {
        setState(() {
          UnitText = data.unit == SpeedUnit.kbps ? 'kb/s' : 'Mb/s';
          _uploadRate = data.transferRate;
          displayrate = _uploadRate;
        });
      },
    );
  }

  Future<void> saveResult(SpeedTestResult result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    history.add(jsonEncode(result.toJson()));
    await prefs.setStringList('history', history);
  }

  void resetValue() {
    setState(() {
      _downloadRate = 0;
      _uploadRate = 0;
      displayrate = 0.0;
      istestingStarted = false;
      _ip = null;
      _isp = null;
      _asn = null;
      displayProgress = 0.0;
    });
  }
}
