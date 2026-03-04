import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:islami_mobile/core/theme.dart';
import 'dart:math' as math;

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _deviceSupport,
      builder: (_, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == false) {
          return const Center(child: Text('Device sensor not supported.'));
        }

        return QiblahCompassWidget();
      },
    );
  }
}

class QiblahCompassWidget extends StatelessWidget {
  const QiblahCompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final qiblahDirection = snapshot.data!;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Direction to Kaaba',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: (qiblahDirection.direction * (math.pi / 180) * -1),
                    child: Image.asset('assets/images/compass.png', height: 300, errorBuilder: (_, _, _) => _fallbackCompass()),
                  ),
                  Transform.rotate(
                    angle: (qiblahDirection.qiblah * (math.pi / 180) * -1),
                    child: Image.asset('assets/images/needle.png', height: 300, errorBuilder: (_, _, _) => _fallbackNeedle()),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '${qiblahDirection.offset.toStringAsFixed(2)}°',
                style: const TextStyle(fontSize: 20, color: IslamiTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fallbackCompass() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: IslamiTheme.primaryColor, width: 4),
      ),
      child: Center(
        child: Text('N', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: IslamiTheme.primaryColor)),
      ),
    );
  }

  Widget _fallbackNeedle() {
    return SizedBox(
      width: 300,
      height: 300,
      child: Center(
        child: Icon(Icons.navigation, color: IslamiTheme.accentColor, size: 60),
      ),
    );
  }
}
