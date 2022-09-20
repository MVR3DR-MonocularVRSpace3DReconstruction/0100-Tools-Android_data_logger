import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class Track extends StatefulWidget{
  const Track({Key? key}) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Text('能力有限，开发中（咕咕咕）\n _(:з」∠)_'),
      ),
    );
  }
}
//
// import 'dart:math' as math;
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
//
// class Track extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Cube rotations',
//       home: Container(
//         color: Colors.black,
//         padding: EdgeInsets.all(32),
//         child: const TestCubeWidget(),
//       ),
//     );
//   }
// }
//
// class TestCubeWidget extends StatelessWidget {
//   const TestCubeWidget();
//
//   @override
//   Widget build(BuildContext context) {
//     var _offset = Offset.zero;
//     return StatefulBuilder(
//       builder: (context, setState) => GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onPanUpdate: (details) {
//           setState(() => _offset += details.delta);
//         },
//         onDoubleTap: () {
//           setState(() => _offset = Offset.zero);
//         },
//         child: CustomPaint(
//           foregroundPainter: _CubePainter(
//             angleX: -0.01 * _offset.dx + math.pi / 8,
//             angleY: 0.01 * _offset.dy + math.pi / 8,
//             colors: [
//               Color.fromARGB(255, 0, 255, 0),
//               Color.fromARGB(255, 255, 255, 0),
//               Color.fromARGB(255, 255, 165, 0),
//               Color.fromARGB(255, 255, 0, 0),
//               Color.fromARGB(255, 255, 255, 255),
//               Color.fromARGB(255, 0, 0, 255),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _CubePainter extends CustomPainter {
//   static final light = Vector3(0, 0, -1);
//   static final specularLight = Colors.white.withOpacity(0.9);
//
//   final List<Color> colors;
//   final double angleX;
//   final double angleY;
//
//   List<Matrix4> _positions;
//
//   _CubePainter({
//     this.angleX,
//     this.angleY,
//     this.colors,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cubeSize = size.shortestSide / 3;
//
//     final side = Rect.fromLTRB(-cubeSize, -cubeSize, cubeSize, cubeSize);
//     final v1 = Vector3(cubeSize, cubeSize, 0);
//     final v2 = Vector3(-cubeSize, cubeSize, 0);
//     final v3 = Vector3(-cubeSize, -cubeSize, 0);
//
//     _positions = [
//       Matrix4.identity()..translate(0.0, 0.0, -cubeSize),
//       Matrix4.identity()
//         ..rotate(Vector3(1, 0, 0), -math.pi / 2)
//         ..translate(0.0, 0.0, -cubeSize),
//       Matrix4.identity()
//         ..rotate(Vector3(0, 1, 0), -math.pi / 2)
//         ..translate(0.0, 0.0, -cubeSize),
//       Matrix4.identity()
//         ..rotate(Vector3(0, 1, 0), math.pi / 2)
//         ..translate(0.0, 0.0, -cubeSize),
//       Matrix4.identity()
//         ..rotate(Vector3(1, 0, 0), math.pi / 2)
//         ..translate(0.0, 0.0, -cubeSize),
//       Matrix4.identity()
//         ..rotate(Vector3(0, 1, 0), math.pi)
//         ..translate(0.0, 0.0, -cubeSize)
//     ];
//
//     final cameraMatrix = Matrix4.identity()
//       ..translate(size.width / 2, size.height / 2)
//       ..multiply(Matrix4.identity()
//         ..setEntry(3, 2, 0.0008)
//         ..rotateX(angleY)
//         ..rotateY(angleX));
//     final cameraPos = cameraMatrix.transform3(Vector3.zero());
//
//     List<int> sortedKeys = createZOrder(cameraMatrix, side);
//     for (int i in sortedKeys) {
//       final finalMatrix = cameraMatrix.multiplied(_positions[i]);
//       canvas.save();
//
//       final normalVector = normalVector3(
//         finalMatrix.transformed3(v1),
//         finalMatrix.transformed3(v2),
//         finalMatrix.transformed3(v3),
//       ).normalized();
//
//       canvas.transform(finalMatrix.storage);
//
//       final directionBrightness = normalVector.dot(light).clamp(0.0, 1.0);
//       canvas.drawRect(side, Paint()..color = colors[i].withBrightness(directionBrightness * 0.6 + 0.4));
//       canvas.restore();
//     }
//   }
//
//   List<int> createZOrder(Matrix4 matrix, Rect side) {
//     final renderOrder = <int, double>{};
//     final pos = Vector3.zero();
//     for (int i = 0; i < _positions.length; i++) {
//       var tmp = matrix.multiplied(_positions[i]);
//       pos.x = side.center.dx;
//       pos.y = side.center.dy;
//       pos.z = 0.0;
//       var t = tmp.transform3(pos).z;
//       renderOrder[i] = t;
//     }
//
//     return renderOrder.keys.toList(growable: false)..sort((a, b) => renderOrder[b].compareTo(renderOrder[a]));
//   }
//
//   @override
//   bool shouldRepaint(_CubePainter oldDelegate) => true;
// }
//
// Vector3 normalVector3(Vector3 v1, Vector3 v2, Vector3 v3) {
//   Vector3 s1 = Vector3.copy(v2);
//   s1.sub(v1);
//   Vector3 s3 = Vector3.copy(v2);
//   s3.sub(v3);
//
//   return Vector3(
//     (s1.y * s3.z) - (s1.z * s3.y),
//     (s1.z * s3.x) - (s1.x * s3.z),
//     (s1.x * s3.y) - (s1.y * s3.x),
//   );
// }
//
// Vector3 reflect(Vector3 d, Vector3 n) {
//   return d - n * 2 * d.dot(n);
// }
//
// Vector3 intersectLineWithPlane(
//     Vector3 vectorPoint,
//     Vector3 vectorDirection,
//     Vector3 planePoint,
//     Vector3 planeNormal,
//     ) {
//   final vn = vectorDirection.dot(planeNormal);
//   if (vn.abs() < 0.00000000000001) {
//     return null;
//   }
//   final d = (planePoint - vectorPoint).dot(planeNormal) / vn;
//   return vectorPoint + vectorDirection * d;
// }
//
// extension ColorUtil on Color {
//   Color withBrightness(double value) {
//     return Color.fromARGB(
//       alpha,
//       (red * value).toInt(),
//       (green * value).toInt(),
//       (blue * value).toInt(),
//     );
//   }
// }
//
// // Vector, Vector3, Matrix4 from math_64, because can not import it into codepan
// /// Base class for vectors
// abstract class Vector {
//   List<double> get storage;
// }
//
// /// 3D column vector.
// class Vector3 implements Vector {
//   final Float64List _v3storage;
//
//   /// The components of the vector.
//   @override
//   Float64List get storage => _v3storage;
//
//   /// Set the values of [result] to the minimum of [a] and [b] for each line.
//   static void min(Vector3 a, Vector3 b, Vector3 result) {
//     result
//       ..x = math.min(a.x, b.x)
//       ..y = math.min(a.y, b.y)
//       ..z = math.min(a.z, b.z);
//   }
//
//   /// Set the values of [result] to the maximum of [a] and [b] for each line.
//   static void max(Vector3 a, Vector3 b, Vector3 result) {
//     result
//       ..x = math.max(a.x, b.x)
//       ..y = math.max(a.y, b.y)
//       ..z = math.max(a.z, b.z);
//   }
//
//   /// Interpolate between [min] and [max] with the amount of [a] using a linear
//   /// interpolation and store the values in [result].
//   static void mix(Vector3 min, Vector3 max, double a, Vector3 result) {
//     result
//       ..x = min.x + a * (max.x - min.x)
//       ..y = min.y + a * (max.y - min.y)
//       ..z = min.z + a * (max.z - min.z);
//   }
//
//   /// Construct a new vector with the specified values.
//   factory Vector3(double x, double y, double z) => new Vector3.zero()..setValues(x, y, z);
//
//   /// Initialized with values from [array] starting at [offset].
//   factory Vector3.array(List<double> array, [int offset = 0]) => new Vector3.zero()..copyFromArray(array, offset);
//
//   /// Zero vector.
//   Vector3.zero() : _v3storage = new Float64List(3);
//
//   /// Splat [value] into all lanes of the vector.
//   factory Vector3.all(double value) => new Vector3.zero()..splat(value);
//
//   /// Copy of [other].
//   factory Vector3.copy(Vector3 other) => new Vector3.zero()..setFrom(other);
//
//   /// Constructs Vector3 with given Float64List as [storage].
//   Vector3.fromFloat64List(this._v3storage);
//
//   /// Constructs Vector3 with a [storage] that views given [buffer] starting at
//   /// [offset]. [offset] has to be multiple of [Float64List.bytesPerElement].
//   Vector3.fromBuffer(ByteBuffer buffer, int offset) : _v3storage = new Float64List.view(buffer, offset, 3);
//
//   /// Set the values of the vector.
//   void setValues(double x, double y, double z) {
//     _v3storage[0] = x;
//     _v3storage[1] = y;
//     _v3storage[2] = z;
//   }
//
//   /// Zero vector.
//   void setZero() {
//     _v3storage[2] = 0.0;
//     _v3storage[1] = 0.0;
//     _v3storage[0] = 0.0;
//   }
//
//   /// Set the values by copying them from [other].
//   void setFrom(Vector3 other) {
//     final Float64List otherStorage = other._v3storage;
//     _v3storage[0] = otherStorage[0];
//     _v3storage[1] = otherStorage[1];
//     _v3storage[2] = otherStorage[2];
//   }
//
//   /// Splat [arg] into all lanes of the vector.
//   void splat(double arg) {
//     _v3storage[2] = arg;
//     _v3storage[1] = arg;
//     _v3storage[0] = arg;
//   }
//
//   /// Returns a printable string
//   @override
//   String toString() => '[${storage[0]},${storage[1]},${storage[2]}]';
//
//   /// Negate
//   Vector3 operator -() => clone()..negate();
//
//   /// Subtract two vectors.
//   Vector3 operator -(Vector3 other) => clone()..sub(other);
//
//   /// Add two vectors.
//   Vector3 operator +(Vector3 other) => clone()..add(other);
//
//   /// Scale.
//   Vector3 operator /(double scale) => scaled(1.0 / scale);
//
//   /// Scale by [scale].
//   Vector3 operator *(double scale) => scaled(scale);
//
//   /// Access the component of the vector at the index [i].
//   double operator [](int i) => _v3storage[i];
//
//   /// Set the component of the vector at the index [i].
//   void operator []=(int i, double v) {
//     _v3storage[i] = v;
//   }
//
//   /// Set the length of the vector. A negative [value] will change the vectors
//   /// orientation and a [value] of zero will set the vector to zero.
//   set length(double value) {
//     if (value == 0.0) {
//       setZero();
//     } else {
//       double l = length;
//       if (l == 0.0) {
//         return;
//       }
//       l = value / l;
//       _v3storage[0] *= l;
//       _v3storage[1] *= l;
//       _v3storage[2] *= l;
//     }
//   }
//
//   /// Length.
//   double get length => math.sqrt(length2);
//
//   /// Length squared.
//   double get length2 {
//     double sum;
//     sum = (_v3storage[0] * _v3storage[0]);
//     sum += (_v3storage[1] * _v3storage[1]);
//     sum += (_v3storage[2] * _v3storage[2]);
//     return sum;
//   }
//
//   /// Normalizes [this].
//   double normalize() {
//     final double l = length;
//     if (l == 0.0) {
//       return 0.0;
//     }
//     final double d = 1.0 / l;
//     _v3storage[0] *= d;
//     _v3storage[1] *= d;
//     _v3storage[2] *= d;
//     return l;
//   }
//
//   /// Normalize [this]. Returns length of vector before normalization.
//   /// DEPRCATED: Use [normalize].
//   @deprecated
//   double normalizeLength() => normalize();
//
//   /// Normalizes copy of [this].
//   Vector3 normalized() => new Vector3.copy(this)..normalize();
//
//   /// Normalize vector into [out].
//   Vector3 normalizeInto(Vector3 out) {
//     out
//       ..setFrom(this)
//       ..normalize();
//     return out;
//   }
//
//   /// Distance from [this] to [arg]
//   double distanceTo(Vector3 arg) => math.sqrt(distanceToSquared(arg));
//
//   /// Squared distance from [this] to [arg]
//   double distanceToSquared(Vector3 arg) {
//     final Float64List argStorage = arg._v3storage;
//     final double dx = _v3storage[0] - argStorage[0];
//     final double dy = _v3storage[1] - argStorage[1];
//     final double dz = _v3storage[2] - argStorage[2];
//
//     return dx * dx + dy * dy + dz * dz;
//   }
//
//   /// Returns the angle between [this] vector and [other] in radians.
//   double angleTo(Vector3 other) {
//     final Float64List otherStorage = other._v3storage;
//     if (_v3storage[0] == otherStorage[0] && _v3storage[1] == otherStorage[1] && _v3storage[2] == otherStorage[2]) {
//       return 0.0;
//     }
//
//     final double d = dot(other) / (length * other.length);
//
//     return math.acos(d.clamp(-1.0, 1.0));
//   }
//
//   /// Returns the signed angle between [this] and [other] around [normal]
//   /// in radians.
//   double angleToSigned(Vector3 other, Vector3 normal) {
//     final double angle = angleTo(other);
//     final Vector3 c = cross(other);
//     final double d = c.dot(normal);
//
//     return d < 0.0 ? -angle : angle;
//   }
//
//   /// Inner product.
//   double dot(Vector3 other) {
//     final Float64List otherStorage = other._v3storage;
//     double sum;
//     sum = _v3storage[0] * otherStorage[0];
//     sum += _v3storage[1] * otherStorage[1];
//     sum += _v3storage[2] * otherStorage[2];
//     return sum;
//   }
//
//   /// Cross product.
//   Vector3 cross(Vector3 other) {
//     final double _x = _v3storage[0];
//     final double _y = _v3storage[1];
//     final double _z = _v3storage[2];
//     final Float64List otherStorage = other._v3storage;
//     final double ox = otherStorage[0];
//     final double oy = otherStorage[1];
//     final double oz = otherStorage[2];
//     return new Vector3(_y * oz - _z * oy, _z * ox - _x * oz, _x * oy - _y * ox);
//   }
//
//   /// Cross product. Stores result in [out].
//   Vector3 crossInto(Vector3 other, Vector3 out) {
//     final double x = _v3storage[0];
//     final double y = _v3storage[1];
//     final double z = _v3storage[2];
//     final Float64List otherStorage = other._v3storage;
//     final double ox = otherStorage[0];
//     final double oy = otherStorage[1];
//     final double oz = otherStorage[2];
//     final Float64List outStorage = out._v3storage;
//     outStorage[0] = y * oz - z * oy;
//     outStorage[1] = z * ox - x * oz;
//     outStorage[2] = x * oy - y * ox;
//     return out;
//   }
//
//   /// Reflect [this].
//   void reflect(Vector3 normal) {
//     sub(normal.scaled(2.0 * normal.dot(this)));
//   }
//
//   /// Reflected copy of [this].
//   Vector3 reflected(Vector3 normal) => clone()..reflect(normal);
//
//   /// Projects [this] using the projection matrix [arg]
//   void applyProjection(Matrix4 arg) {
//     final Float64List argStorage = arg.storage;
//     final double x = _v3storage[0];
//     final double y = _v3storage[1];
//     final double z = _v3storage[2];
//     final double d = 1.0 / (argStorage[3] * x + argStorage[7] * y + argStorage[11] * z + argStorage[15]);
//     _v3storage[0] = (argStorage[0] * x + argStorage[4] * y + argStorage[8] * z + argStorage[12]) * d;
//     _v3storage[1] = (argStorage[1] * x + argStorage[5] * y + argStorage[9] * z + argStorage[13]) * d;
//     _v3storage[2] = (argStorage[2] * x + argStorage[6] * y + argStorage[10] * z + argStorage[14]) * d;
//   }
//
//   /// Add [arg] to [this].
//   void add(Vector3 arg) {
//     final Float64List argStorage = arg._v3storage;
//     _v3storage[0] = _v3storage[0] + argStorage[0];
//     _v3storage[1] = _v3storage[1] + argStorage[1];
//     _v3storage[2] = _v3storage[2] + argStorage[2];
//   }
//
//   /// Add [arg] scaled by [factor] to [this].
//   void addScaled(Vector3 arg, double factor) {
//     final Float64List argStorage = arg._v3storage;
//     _v3storage[0] = _v3storage[0] + argStorage[0] * factor;
//     _v3storage[1] = _v3storage[1] + argStorage[1] * factor;
//     _v3storage[2] = _v3storage[2] + argStorage[2] * factor;
//   }
//
//   /// Subtract [arg] from [this].
//   void sub(Vector3 arg) {
//     final Float64List argStorage = arg._v3storage;
//     _v3storage[0] = _v3storage[0] - argStorage[0];
//     _v3storage[1] = _v3storage[1] - argStorage[1];
//     _v3storage[2] = _v3storage[2] - argStorage[2];
//   }
//
//   /// Multiply entries in [this] with entries in [arg].
//   void multiply(Vector3 arg) {
//     final Float64List argStorage = arg._v3storage;
//     _v3storage[0] = _v3storage[0] * argStorage[0];
//     _v3storage[1] = _v3storage[1] * argStorage[1];
//     _v3storage[2] = _v3storage[2] * argStorage[2];
//   }
//
//   /// Divide entries in [this] with entries in [arg].
//   void divide(Vector3 arg) {
//     final Float64List argStorage = arg._v3storage;
//     _v3storage[0] = _v3storage[0] / argStorage[0];
//     _v3storage[1] = _v3storage[1] / argStorage[1];
//     _v3storage[2] = _v3storage[2] / argStorage[2];
//   }
//
//   /// Scale [this].
//   void scale(double arg) {
//     _v3storage[2] = _v3storage[2] * arg;
//     _v3storage[1] = _v3storage[1] * arg;
//     _v3storage[0] = _v3storage[0] * arg;
//   }
//
//   /// Create a copy of [this] and scale it by [arg].
//   Vector3 scaled(double arg) => clone()..scale(arg);
//
//   /// Negate [this].
//   void negate() {
//     _v3storage[2] = -_v3storage[2];
//     _v3storage[1] = -_v3storage[1];
//     _v3storage[0] = -_v3storage[0];
//   }
//
//   /// Absolute value.
//   void absolute() {
//     _v3storage[0] = _v3storage[0].abs();
//     _v3storage[1] = _v3storage[1].abs();
//     _v3storage[2] = _v3storage[2].abs();
//   }
//
//   /// Clone of [this].
//   Vector3 clone() => new Vector3.copy(this);
//
//   /// Copy [this] into [arg].
//   Vector3 copyInto(Vector3 arg) {
//     final Float64List argStorage = arg._v3storage;
//     argStorage[0] = _v3storage[0];
//     argStorage[1] = _v3storage[1];
//     argStorage[2] = _v3storage[2];
//     return arg;
//   }
//
//   /// Copies [this] into [array] starting at [offset].
//   void copyIntoArray(List<double> array, [int offset = 0]) {
//     array[offset + 2] = _v3storage[2];
//     array[offset + 1] = _v3storage[1];
//     array[offset + 0] = _v3storage[0];
//   }
//
//   /// Copies elements from [array] into [this] starting at [offset].
//   void copyFromArray(List<double> array, [int offset = 0]) {
//     _v3storage[2] = array[offset + 2];
//     _v3storage[1] = array[offset + 1];
//     _v3storage[0] = array[offset + 0];
//   }
//
//   set x(double arg) => _v3storage[0] = arg;
//
//   set y(double arg) => _v3storage[1] = arg;
//
//   set z(double arg) => _v3storage[2] = arg;
//
//   double get x => _v3storage[0];
//
//   double get y => _v3storage[1];
//
//   double get z => _v3storage[2];
// }
//
// /// 4D Matrix.
// /// Values are stored in column major order.
// class Matrix4 {
//   final Float64List _m4storage;
//
//   /// The components of the matrix.
//   Float64List get storage => _m4storage;
//
//   /// Return index in storage for [row], [col] value.
//   int index(int row, int col) => (col * 4) + row;
//
//   /// Value at [row], [col].
//   double entry(int row, int col) {
//     assert((row >= 0) && (row < dimension));
//     assert((col >= 0) && (col < dimension));
//
//     return _m4storage[index(row, col)];
//   }
//
//   /// Set value at [row], [col] to be [v].
//   void setEntry(int row, int col, double v) {
//     assert((row >= 0) && (row < dimension));
//     assert((col >= 0) && (col < dimension));
//
//     _m4storage[index(row, col)] = v;
//   }
//
//   /// Zero matrix.
//   Matrix4.zero() : _m4storage = new Float64List(16);
//
//   /// Identity matrix.
//   factory Matrix4.identity() => new Matrix4.zero()..setIdentity();
//
//   /// Copies values from [other].
//   factory Matrix4.copy(Matrix4 other) => new Matrix4.zero()..setFrom(other);
//
//   /// Rotation of [radians_] around X.
//   factory Matrix4.rotationX(double radians) => new Matrix4.zero()
//     .._m4storage[15] = 1.0
//     ..setRotationX(radians);
//
//   /// Rotation of [radians_] around Y.
//   factory Matrix4.rotationY(double radians) => new Matrix4.zero()
//     .._m4storage[15] = 1.0
//     ..setRotationY(radians);
//
//   /// Rotation of [radians_] around Z.
//   factory Matrix4.rotationZ(double radians) => new Matrix4.zero()
//     .._m4storage[15] = 1.0
//     ..setRotationZ(radians);
//
//   /// Translation matrix.
//   factory Matrix4.translation(Vector3 translation) => new Matrix4.zero()
//     ..setIdentity()
//     ..setTranslation(translation);
//
//   /// Translation matrix.
//   factory Matrix4.translationValues(double x, double y, double z) => new Matrix4.zero()
//     ..setIdentity()
//     ..setTranslationRaw(x, y, z);
//
//   /// Scale matrix.
//   factory Matrix4.diagonal3(Vector3 scale) {
//     final Matrix4 m = new Matrix4.zero();
//     final Float64List mStorage = m._m4storage;
//     final Float64List scaleStorage = scale._v3storage;
//     mStorage[15] = 1.0;
//     mStorage[10] = scaleStorage[2];
//     mStorage[5] = scaleStorage[1];
//     mStorage[0] = scaleStorage[0];
//     return m;
//   }
//
//   /// Scale matrix.
//   factory Matrix4.diagonal3Values(double x, double y, double z) => new Matrix4.zero()
//     .._m4storage[15] = 1.0
//     .._m4storage[10] = z
//     .._m4storage[5] = y
//     .._m4storage[0] = x;
//
//   /// Skew matrix around X axis
//   factory Matrix4.skewX(double alpha) {
//     final Matrix4 m = new Matrix4.identity();
//     m._m4storage[4] = math.tan(alpha);
//     return m;
//   }
//
//   /// Skew matrix around Y axis.
//   factory Matrix4.skewY(double beta) {
//     final Matrix4 m = new Matrix4.identity();
//     m._m4storage[1] = math.tan(beta);
//     return m;
//   }
//
//   /// Skew matrix around X axis (alpha) and Y axis (beta).
//   factory Matrix4.skew(double alpha, double beta) {
//     final Matrix4 m = new Matrix4.identity();
//     m._m4storage[1] = math.tan(beta);
//     m._m4storage[4] = math.tan(alpha);
//     return m;
//   }
//
//   /// Constructs a matrix that is the inverse of [other].
//   factory Matrix4.inverted(Matrix4 other) {
//     final Matrix4 r = new Matrix4.zero();
//     final double determinant = r.copyInverse(other);
//     if (determinant == 0.0) {
//       throw new ArgumentError.value(other, 'other', 'Matrix cannot be inverted');
//     }
//     return r;
//   }
//
//   /// Constructs Matrix4 with given [Float64List] as [storage].
//   Matrix4.fromFloat64List(this._m4storage);
//
//   /// Constructs Matrix4 with a [storage] that views given [buffer] starting at
//   /// [offset]. [offset] has to be multiple of [Float64List.bytesPerElement].
//   Matrix4.fromBuffer(ByteBuffer buffer, int offset) : _m4storage = new Float64List.view(buffer, offset, 16);
//
//   /// Sets the diagonal to [arg].
//   void splatDiagonal(double arg) {
//     _m4storage[0] = arg;
//     _m4storage[5] = arg;
//     _m4storage[10] = arg;
//     _m4storage[15] = arg;
//   }
//
//   /// Sets the entire matrix to the matrix in [arg].
//   void setFrom(Matrix4 arg) {
//     final Float64List argStorage = arg._m4storage;
//     _m4storage[15] = argStorage[15];
//     _m4storage[14] = argStorage[14];
//     _m4storage[13] = argStorage[13];
//     _m4storage[12] = argStorage[12];
//     _m4storage[11] = argStorage[11];
//     _m4storage[10] = argStorage[10];
//     _m4storage[9] = argStorage[9];
//     _m4storage[8] = argStorage[8];
//     _m4storage[7] = argStorage[7];
//     _m4storage[6] = argStorage[6];
//     _m4storage[5] = argStorage[5];
//     _m4storage[4] = argStorage[4];
//     _m4storage[3] = argStorage[3];
//     _m4storage[2] = argStorage[2];
//     _m4storage[1] = argStorage[1];
//     _m4storage[0] = argStorage[0];
//   }
//
//   /// Returns a printable string
//   @override
//   String toString() => '[0] ${getRow(0)}\n[1] ${getRow(1)}\n'
//       '[2] ${getRow(2)}\n[3] ${getRow(3)}\n';
//
//   /// Dimension of the matrix.
//   int get dimension => 4;
//
//   /// Access the element of the matrix at the index [i].
//   double operator [](int i) => _m4storage[i];
//
//   /// Set the element of the matrix at the index [i].
//   void operator []=(int i, double v) {
//     _m4storage[i] = v;
//   }
//
//   /// Returns row 0
//   List<double> get row0 => getRow(0);
//
//   /// Returns row 1
//   List<double> get row1 => getRow(1);
//
//   /// Returns row 2
//   List<double> get row2 => getRow(2);
//
//   /// Returns row 3
//   List<double> get row3 => getRow(3);
//
//   /// Gets the [row] of the matrix
//   List<double> getRow(int row) {
//     final rStorage = <double>[];
//     rStorage[0] = _m4storage[index(row, 0)];
//     rStorage[1] = _m4storage[index(row, 1)];
//     rStorage[2] = _m4storage[index(row, 2)];
//     rStorage[3] = _m4storage[index(row, 3)];
//     return rStorage;
//   }
//
//   /// Clone matrix.
//   Matrix4 clone() => new Matrix4.copy(this);
//
//   /// Returns new matrix -this
//   Matrix4 operator -() => clone()..negate();
//
//   /// Returns a new vector or matrix by multiplying [this] with [arg].
//   dynamic operator *(dynamic arg) {
//     if (arg is double) {
//       return scaled(arg);
//     }
//     if (arg is Vector3) {
//       return transformed3(arg);
//     }
//     if (arg is Matrix4) {
//       return multiplied(arg);
//     }
//     throw new ArgumentError(arg);
//   }
//
//   /// Returns new matrix after component wise [this] + [arg]
//   Matrix4 operator +(Matrix4 arg) => clone()..add(arg);
//
//   /// Returns new matrix after component wise [this] - [arg]
//   Matrix4 operator -(Matrix4 arg) => clone()..sub(arg);
//
//   /// Translate this matrix by a [Vector3], [Vector4], or x,y,z
//   void translate(dynamic x, [double y = 0.0, double z = 0.0]) {
//     double tx;
//     double ty;
//     double tz;
//     final double tw = 1.0;
//     if (x is Vector3) {
//       tx = x.x;
//       ty = x.y;
//       tz = x.z;
//     } else if (x is double) {
//       tx = x;
//       ty = y;
//       tz = z;
//     }
//     final double t1 = _m4storage[0] * tx + _m4storage[4] * ty + _m4storage[8] * tz + _m4storage[12] * tw;
//     final double t2 = _m4storage[1] * tx + _m4storage[5] * ty + _m4storage[9] * tz + _m4storage[13] * tw;
//     final double t3 = _m4storage[2] * tx + _m4storage[6] * ty + _m4storage[10] * tz + _m4storage[14] * tw;
//     final double t4 = _m4storage[3] * tx + _m4storage[7] * ty + _m4storage[11] * tz + _m4storage[15] * tw;
//     _m4storage[12] = t1;
//     _m4storage[13] = t2;
//     _m4storage[14] = t3;
//     _m4storage[15] = t4;
//   }
//
//   /// Rotate this [angle] radians around [axis]
//   void rotate(Vector3 axis, double angle) {
//     final double len = axis.length;
//     final Float64List axisStorage = axis._v3storage;
//     final double x = axisStorage[0] / len;
//     final double y = axisStorage[1] / len;
//     final double z = axisStorage[2] / len;
//     final double c = math.cos(angle);
//     final double s = math.sin(angle);
//     final double C = 1.0 - c;
//     final double m11 = x * x * C + c;
//     final double m12 = x * y * C - z * s;
//     final double m13 = x * z * C + y * s;
//     final double m21 = y * x * C + z * s;
//     final double m22 = y * y * C + c;
//     final double m23 = y * z * C - x * s;
//     final double m31 = z * x * C - y * s;
//     final double m32 = z * y * C + x * s;
//     final double m33 = z * z * C + c;
//     final double t1 = _m4storage[0] * m11 + _m4storage[4] * m21 + _m4storage[8] * m31;
//     final double t2 = _m4storage[1] * m11 + _m4storage[5] * m21 + _m4storage[9] * m31;
//     final double t3 = _m4storage[2] * m11 + _m4storage[6] * m21 + _m4storage[10] * m31;
//     final double t4 = _m4storage[3] * m11 + _m4storage[7] * m21 + _m4storage[11] * m31;
//     final double t5 = _m4storage[0] * m12 + _m4storage[4] * m22 + _m4storage[8] * m32;
//     final double t6 = _m4storage[1] * m12 + _m4storage[5] * m22 + _m4storage[9] * m32;
//     final double t7 = _m4storage[2] * m12 + _m4storage[6] * m22 + _m4storage[10] * m32;
//     final double t8 = _m4storage[3] * m12 + _m4storage[7] * m22 + _m4storage[11] * m32;
//     final double t9 = _m4storage[0] * m13 + _m4storage[4] * m23 + _m4storage[8] * m33;
//     final double t10 = _m4storage[1] * m13 + _m4storage[5] * m23 + _m4storage[9] * m33;
//     final double t11 = _m4storage[2] * m13 + _m4storage[6] * m23 + _m4storage[10] * m33;
//     final double t12 = _m4storage[3] * m13 + _m4storage[7] * m23 + _m4storage[11] * m33;
//     _m4storage[0] = t1;
//     _m4storage[1] = t2;
//     _m4storage[2] = t3;
//     _m4storage[3] = t4;
//     _m4storage[4] = t5;
//     _m4storage[5] = t6;
//     _m4storage[6] = t7;
//     _m4storage[7] = t8;
//     _m4storage[8] = t9;
//     _m4storage[9] = t10;
//     _m4storage[10] = t11;
//     _m4storage[11] = t12;
//   }
//
//   /// Rotate this [angle] radians around X
//   void rotateX(double angle) {
//     final double cosAngle = math.cos(angle);
//     final double sinAngle = math.sin(angle);
//     final double t1 = _m4storage[4] * cosAngle + _m4storage[8] * sinAngle;
//     final double t2 = _m4storage[5] * cosAngle + _m4storage[9] * sinAngle;
//     final double t3 = _m4storage[6] * cosAngle + _m4storage[10] * sinAngle;
//     final double t4 = _m4storage[7] * cosAngle + _m4storage[11] * sinAngle;
//     final double t5 = _m4storage[4] * -sinAngle + _m4storage[8] * cosAngle;
//     final double t6 = _m4storage[5] * -sinAngle + _m4storage[9] * cosAngle;
//     final double t7 = _m4storage[6] * -sinAngle + _m4storage[10] * cosAngle;
//     final double t8 = _m4storage[7] * -sinAngle + _m4storage[11] * cosAngle;
//     _m4storage[4] = t1;
//     _m4storage[5] = t2;
//     _m4storage[6] = t3;
//     _m4storage[7] = t4;
//     _m4storage[8] = t5;
//     _m4storage[9] = t6;
//     _m4storage[10] = t7;
//     _m4storage[11] = t8;
//   }
//
//   /// Rotate this matrix [angle] radians around Y
//   void rotateY(double angle) {
//     final double cosAngle = math.cos(angle);
//     final double sinAngle = math.sin(angle);
//     final double t1 = _m4storage[0] * cosAngle + _m4storage[8] * -sinAngle;
//     final double t2 = _m4storage[1] * cosAngle + _m4storage[9] * -sinAngle;
//     final double t3 = _m4storage[2] * cosAngle + _m4storage[10] * -sinAngle;
//     final double t4 = _m4storage[3] * cosAngle + _m4storage[11] * -sinAngle;
//     final double t5 = _m4storage[0] * sinAngle + _m4storage[8] * cosAngle;
//     final double t6 = _m4storage[1] * sinAngle + _m4storage[9] * cosAngle;
//     final double t7 = _m4storage[2] * sinAngle + _m4storage[10] * cosAngle;
//     final double t8 = _m4storage[3] * sinAngle + _m4storage[11] * cosAngle;
//     _m4storage[0] = t1;
//     _m4storage[1] = t2;
//     _m4storage[2] = t3;
//     _m4storage[3] = t4;
//     _m4storage[8] = t5;
//     _m4storage[9] = t6;
//     _m4storage[10] = t7;
//     _m4storage[11] = t8;
//   }
//
//   /// Rotate this matrix [angle] radians around Z
//   void rotateZ(double angle) {
//     final double cosAngle = math.cos(angle);
//     final double sinAngle = math.sin(angle);
//     final double t1 = _m4storage[0] * cosAngle + _m4storage[4] * sinAngle;
//     final double t2 = _m4storage[1] * cosAngle + _m4storage[5] * sinAngle;
//     final double t3 = _m4storage[2] * cosAngle + _m4storage[6] * sinAngle;
//     final double t4 = _m4storage[3] * cosAngle + _m4storage[7] * sinAngle;
//     final double t5 = _m4storage[0] * -sinAngle + _m4storage[4] * cosAngle;
//     final double t6 = _m4storage[1] * -sinAngle + _m4storage[5] * cosAngle;
//     final double t7 = _m4storage[2] * -sinAngle + _m4storage[6] * cosAngle;
//     final double t8 = _m4storage[3] * -sinAngle + _m4storage[7] * cosAngle;
//     _m4storage[0] = t1;
//     _m4storage[1] = t2;
//     _m4storage[2] = t3;
//     _m4storage[3] = t4;
//     _m4storage[4] = t5;
//     _m4storage[5] = t6;
//     _m4storage[6] = t7;
//     _m4storage[7] = t8;
//   }
//
//   /// Scale this matrix by a [Vector3], [Vector4], or x,y,z
//   void scale(dynamic x, [double y, double z]) {
//     double sx;
//     double sy;
//     double sz;
//     final double sw = 1.0;
//     if (x is Vector3) {
//       sx = x.x;
//       sy = x.y;
//       sz = x.z;
//     } else if (x is double) {
//       sx = x;
//       sy = y ?? x;
//       sz = z ?? x;
//     }
//     _m4storage[0] *= sx;
//     _m4storage[1] *= sx;
//     _m4storage[2] *= sx;
//     _m4storage[3] *= sx;
//     _m4storage[4] *= sy;
//     _m4storage[5] *= sy;
//     _m4storage[6] *= sy;
//     _m4storage[7] *= sy;
//     _m4storage[8] *= sz;
//     _m4storage[9] *= sz;
//     _m4storage[10] *= sz;
//     _m4storage[11] *= sz;
//     _m4storage[12] *= sw;
//     _m4storage[13] *= sw;
//     _m4storage[14] *= sw;
//     _m4storage[15] *= sw;
//   }
//
//   /// Create a copy of [this] scaled by a [Vector3], [Vector4] or [x],[y], and
//   /// [z].
//   Matrix4 scaled(dynamic x, [double y, double z]) => clone()..scale(x, y, z);
//
//   /// Zeros [this].
//   void setZero() {
//     _m4storage[0] = 0.0;
//     _m4storage[1] = 0.0;
//     _m4storage[2] = 0.0;
//     _m4storage[3] = 0.0;
//     _m4storage[4] = 0.0;
//     _m4storage[5] = 0.0;
//     _m4storage[6] = 0.0;
//     _m4storage[7] = 0.0;
//     _m4storage[8] = 0.0;
//     _m4storage[9] = 0.0;
//     _m4storage[10] = 0.0;
//     _m4storage[11] = 0.0;
//     _m4storage[12] = 0.0;
//     _m4storage[13] = 0.0;
//     _m4storage[14] = 0.0;
//     _m4storage[15] = 0.0;
//   }
//
//   /// Makes [this] into the identity matrix.
//   void setIdentity() {
//     _m4storage[0] = 1.0;
//     _m4storage[1] = 0.0;
//     _m4storage[2] = 0.0;
//     _m4storage[3] = 0.0;
//     _m4storage[4] = 0.0;
//     _m4storage[5] = 1.0;
//     _m4storage[6] = 0.0;
//     _m4storage[7] = 0.0;
//     _m4storage[8] = 0.0;
//     _m4storage[9] = 0.0;
//     _m4storage[10] = 1.0;
//     _m4storage[11] = 0.0;
//     _m4storage[12] = 0.0;
//     _m4storage[13] = 0.0;
//     _m4storage[14] = 0.0;
//     _m4storage[15] = 1.0;
//   }
//
//   /// Sets the translation vector in this homogeneous transformation matrix.
//   void setTranslation(Vector3 t) {
//     final Float64List tStorage = t._v3storage;
//     final double z = tStorage[2];
//     final double y = tStorage[1];
//     final double x = tStorage[0];
//     _m4storage[14] = z;
//     _m4storage[13] = y;
//     _m4storage[12] = x;
//   }
//
//   /// Sets the translation vector in this homogeneous transformation matrix.
//   void setTranslationRaw(double x, double y, double z) {
//     _m4storage[14] = z;
//     _m4storage[13] = y;
//     _m4storage[12] = x;
//   }
//
//   /// Sets the upper 3x3 to a rotation of [radians] around X
//   void setRotationX(double radians) {
//     final double c = math.cos(radians);
//     final double s = math.sin(radians);
//     _m4storage[0] = 1.0;
//     _m4storage[1] = 0.0;
//     _m4storage[2] = 0.0;
//     _m4storage[4] = 0.0;
//     _m4storage[5] = c;
//     _m4storage[6] = s;
//     _m4storage[8] = 0.0;
//     _m4storage[9] = -s;
//     _m4storage[10] = c;
//     _m4storage[3] = 0.0;
//     _m4storage[7] = 0.0;
//     _m4storage[11] = 0.0;
//   }
//
//   /// Sets the upper 3x3 to a rotation of [radians] around Y
//   void setRotationY(double radians) {
//     final double c = math.cos(radians);
//     final double s = math.sin(radians);
//     _m4storage[0] = c;
//     _m4storage[1] = 0.0;
//     _m4storage[2] = -s;
//     _m4storage[4] = 0.0;
//     _m4storage[5] = 1.0;
//     _m4storage[6] = 0.0;
//     _m4storage[8] = s;
//     _m4storage[9] = 0.0;
//     _m4storage[10] = c;
//     _m4storage[3] = 0.0;
//     _m4storage[7] = 0.0;
//     _m4storage[11] = 0.0;
//   }
//
//   /// Sets the upper 3x3 to a rotation of [radians] around Z
//   void setRotationZ(double radians) {
//     final double c = math.cos(radians);
//     final double s = math.sin(radians);
//     _m4storage[0] = c;
//     _m4storage[1] = s;
//     _m4storage[2] = 0.0;
//     _m4storage[4] = -s;
//     _m4storage[5] = c;
//     _m4storage[6] = 0.0;
//     _m4storage[8] = 0.0;
//     _m4storage[9] = 0.0;
//     _m4storage[10] = 1.0;
//     _m4storage[3] = 0.0;
//     _m4storage[7] = 0.0;
//     _m4storage[11] = 0.0;
//   }
//
//   /// Adds [o] to [this].
//   void add(Matrix4 o) {
//     final Float64List oStorage = o._m4storage;
//     _m4storage[0] = _m4storage[0] + oStorage[0];
//     _m4storage[1] = _m4storage[1] + oStorage[1];
//     _m4storage[2] = _m4storage[2] + oStorage[2];
//     _m4storage[3] = _m4storage[3] + oStorage[3];
//     _m4storage[4] = _m4storage[4] + oStorage[4];
//     _m4storage[5] = _m4storage[5] + oStorage[5];
//     _m4storage[6] = _m4storage[6] + oStorage[6];
//     _m4storage[7] = _m4storage[7] + oStorage[7];
//     _m4storage[8] = _m4storage[8] + oStorage[8];
//     _m4storage[9] = _m4storage[9] + oStorage[9];
//     _m4storage[10] = _m4storage[10] + oStorage[10];
//     _m4storage[11] = _m4storage[11] + oStorage[11];
//     _m4storage[12] = _m4storage[12] + oStorage[12];
//     _m4storage[13] = _m4storage[13] + oStorage[13];
//     _m4storage[14] = _m4storage[14] + oStorage[14];
//     _m4storage[15] = _m4storage[15] + oStorage[15];
//   }
//
//   /// Subtracts [o] from [this].
//   void sub(Matrix4 o) {
//     final Float64List oStorage = o._m4storage;
//     _m4storage[0] = _m4storage[0] - oStorage[0];
//     _m4storage[1] = _m4storage[1] - oStorage[1];
//     _m4storage[2] = _m4storage[2] - oStorage[2];
//     _m4storage[3] = _m4storage[3] - oStorage[3];
//     _m4storage[4] = _m4storage[4] - oStorage[4];
//     _m4storage[5] = _m4storage[5] - oStorage[5];
//     _m4storage[6] = _m4storage[6] - oStorage[6];
//     _m4storage[7] = _m4storage[7] - oStorage[7];
//     _m4storage[8] = _m4storage[8] - oStorage[8];
//     _m4storage[9] = _m4storage[9] - oStorage[9];
//     _m4storage[10] = _m4storage[10] - oStorage[10];
//     _m4storage[11] = _m4storage[11] - oStorage[11];
//     _m4storage[12] = _m4storage[12] - oStorage[12];
//     _m4storage[13] = _m4storage[13] - oStorage[13];
//     _m4storage[14] = _m4storage[14] - oStorage[14];
//     _m4storage[15] = _m4storage[15] - oStorage[15];
//   }
//
//   /// Negate [this].
//   void negate() {
//     _m4storage[0] = -_m4storage[0];
//     _m4storage[1] = -_m4storage[1];
//     _m4storage[2] = -_m4storage[2];
//     _m4storage[3] = -_m4storage[3];
//     _m4storage[4] = -_m4storage[4];
//     _m4storage[5] = -_m4storage[5];
//     _m4storage[6] = -_m4storage[6];
//     _m4storage[7] = -_m4storage[7];
//     _m4storage[8] = -_m4storage[8];
//     _m4storage[9] = -_m4storage[9];
//     _m4storage[10] = -_m4storage[10];
//     _m4storage[11] = -_m4storage[11];
//     _m4storage[12] = -_m4storage[12];
//     _m4storage[13] = -_m4storage[13];
//     _m4storage[14] = -_m4storage[14];
//     _m4storage[15] = -_m4storage[15];
//   }
//
//   /// Multiply [this] by [arg].
//   void multiply(Matrix4 arg) {
//     final double m00 = _m4storage[0];
//     final double m01 = _m4storage[4];
//     final double m02 = _m4storage[8];
//     final double m03 = _m4storage[12];
//     final double m10 = _m4storage[1];
//     final double m11 = _m4storage[5];
//     final double m12 = _m4storage[9];
//     final double m13 = _m4storage[13];
//     final double m20 = _m4storage[2];
//     final double m21 = _m4storage[6];
//     final double m22 = _m4storage[10];
//     final double m23 = _m4storage[14];
//     final double m30 = _m4storage[3];
//     final double m31 = _m4storage[7];
//     final double m32 = _m4storage[11];
//     final double m33 = _m4storage[15];
//     final Float64List argStorage = arg._m4storage;
//     final double n00 = argStorage[0];
//     final double n01 = argStorage[4];
//     final double n02 = argStorage[8];
//     final double n03 = argStorage[12];
//     final double n10 = argStorage[1];
//     final double n11 = argStorage[5];
//     final double n12 = argStorage[9];
//     final double n13 = argStorage[13];
//     final double n20 = argStorage[2];
//     final double n21 = argStorage[6];
//     final double n22 = argStorage[10];
//     final double n23 = argStorage[14];
//     final double n30 = argStorage[3];
//     final double n31 = argStorage[7];
//     final double n32 = argStorage[11];
//     final double n33 = argStorage[15];
//     _m4storage[0] = (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
//     _m4storage[4] = (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
//     _m4storage[8] = (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
//     _m4storage[12] = (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
//     _m4storage[1] = (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
//     _m4storage[5] = (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
//     _m4storage[9] = (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
//     _m4storage[13] = (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
//     _m4storage[2] = (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
//     _m4storage[6] = (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
//     _m4storage[10] = (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
//     _m4storage[14] = (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
//     _m4storage[3] = (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
//     _m4storage[7] = (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
//     _m4storage[11] = (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
//     _m4storage[15] = (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);
//   }
//
//   /// Multiply a copy of [this] with [arg].
//   Matrix4 multiplied(Matrix4 arg) => clone()..multiply(arg);
//
//   /// Transform [arg] of type [Vector3] using the transformation defined by
//   /// [this].
//   Vector3 transform3(Vector3 arg) {
//     final Float64List argStorage = arg._v3storage;
//     final double x = (_m4storage[0] * argStorage[0]) +
//         (_m4storage[4] * argStorage[1]) +
//         (_m4storage[8] * argStorage[2]) +
//         _m4storage[12];
//     final double y = (_m4storage[1] * argStorage[0]) +
//         (_m4storage[5] * argStorage[1]) +
//         (_m4storage[9] * argStorage[2]) +
//         _m4storage[13];
//     final double z = (_m4storage[2] * argStorage[0]) +
//         (_m4storage[6] * argStorage[1]) +
//         (_m4storage[10] * argStorage[2]) +
//         _m4storage[14];
//     argStorage[0] = x;
//     argStorage[1] = y;
//     argStorage[2] = z;
//     return arg;
//   }
//
//   /// Transform a copy of [arg] of type [Vector3] using the transformation
//   /// defined by [this]. If a [out] parameter is supplied, the copy is stored in
//   /// [out].
//   Vector3 transformed3(Vector3 arg, [Vector3 out]) {
//     if (out == null) {
//       out = new Vector3.copy(arg);
//     } else {
//       out.setFrom(arg);
//     }
//     return transform3(out);
//   }
//
//   /// Set this matrix to be the inverse of [arg]
//   double copyInverse(Matrix4 arg) {
//     final Float64List argStorage = arg._m4storage;
//     final double a00 = argStorage[0];
//     final double a01 = argStorage[1];
//     final double a02 = argStorage[2];
//     final double a03 = argStorage[3];
//     final double a10 = argStorage[4];
//     final double a11 = argStorage[5];
//     final double a12 = argStorage[6];
//     final double a13 = argStorage[7];
//     final double a20 = argStorage[8];
//     final double a21 = argStorage[9];
//     final double a22 = argStorage[10];
//     final double a23 = argStorage[11];
//     final double a30 = argStorage[12];
//     final double a31 = argStorage[13];
//     final double a32 = argStorage[14];
//     final double a33 = argStorage[15];
//     final double b00 = a00 * a11 - a01 * a10;
//     final double b01 = a00 * a12 - a02 * a10;
//     final double b02 = a00 * a13 - a03 * a10;
//     final double b03 = a01 * a12 - a02 * a11;
//     final double b04 = a01 * a13 - a03 * a11;
//     final double b05 = a02 * a13 - a03 * a12;
//     final double b06 = a20 * a31 - a21 * a30;
//     final double b07 = a20 * a32 - a22 * a30;
//     final double b08 = a20 * a33 - a23 * a30;
//     final double b09 = a21 * a32 - a22 * a31;
//     final double b10 = a21 * a33 - a23 * a31;
//     final double b11 = a22 * a33 - a23 * a32;
//     final double det = (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06);
//     if (det == 0.0) {
//       setFrom(arg);
//       return 0.0;
//     }
//     final double invDet = 1.0 / det;
//     _m4storage[0] = (a11 * b11 - a12 * b10 + a13 * b09) * invDet;
//     _m4storage[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet;
//     _m4storage[2] = (a31 * b05 - a32 * b04 + a33 * b03) * invDet;
//     _m4storage[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet;
//     _m4storage[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet;
//     _m4storage[5] = (a00 * b11 - a02 * b08 + a03 * b07) * invDet;
//     _m4storage[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet;
//     _m4storage[7] = (a20 * b05 - a22 * b02 + a23 * b01) * invDet;
//     _m4storage[8] = (a10 * b10 - a11 * b08 + a13 * b06) * invDet;
//     _m4storage[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet;
//     _m4storage[10] = (a30 * b04 - a31 * b02 + a33 * b00) * invDet;
//     _m4storage[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet;
//     _m4storage[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet;
//     _m4storage[13] = (a00 * b09 - a01 * b07 + a02 * b06) * invDet;
//     _m4storage[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet;
//     _m4storage[15] = (a20 * b03 - a21 * b01 + a22 * b00) * invDet;
//     return det;
//   }
// }
