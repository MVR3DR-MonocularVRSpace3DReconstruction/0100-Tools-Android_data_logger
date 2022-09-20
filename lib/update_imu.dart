import 'package:motion_sensors/motion_sensors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

final Vector3 _accelerometer = Vector3.zero();
final Vector3 _gyroscope = Vector3.zero();
final Vector3 _magnetometer = Vector3.zero();
final Vector3 _userAccelerometer = Vector3.zero();
final Vector3 _orientation = Vector3.zero();
final Vector3 _absoluteOrientation = Vector3.zero();
final Vector3 _absoluteOrientation2 = Vector3.zero();

update_imu() {
  // SharedPreferences deviceStorage =
  SharedPreferences.getInstance().then((value) => (() {
      value.setDouble('gyroscopeX', _gyroscope.x);
      value.setDouble('gyroscopeY', _gyroscope.y);
      value.setDouble('gyroscopeZ', _gyroscope.z);

      value.setDouble('accelerometerX', _accelerometer.x);
      value.setDouble('accelerometerY', _accelerometer.y);
      value.setDouble('accelerometerZ', _accelerometer.z);

      value.setDouble('userAccelerometerX', _userAccelerometer.x);
      value.setDouble('userAccelerometerY', _userAccelerometer.y);
      value.setDouble('userAccelerometerZ', _userAccelerometer.z);

      value.setDouble('magnetometerX', _magnetometer.x);
      value.setDouble('magnetometerY', _magnetometer.y);
      value.setDouble('magnetometerZ', _magnetometer.z);

      value.setDouble('orientationX', _orientation.x);
      value.setDouble('orientationY', _orientation.y);
      value.setDouble('orientationZ', _orientation.z);

      value.setDouble('absoluteOrientationX', _absoluteOrientation.x);
      value.setDouble('absoluteOrientationY', _absoluteOrientation.y);
      value.setDouble('absoluteOrientationZ', _absoluteOrientation.z);

      value.setDouble('absoluteOrientation2X', _absoluteOrientation2.x);
      value.setDouble('absoluteOrientation2Y', _absoluteOrientation2.y);
      value.setDouble('absoluteOrientation2Z', _absoluteOrientation2.z);
    }));
}