import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'coordinates_translator.dart';

class PosePainter extends CustomPainter {
  PosePainter(this.poses, this.imageSize, this.rotation,
      this.cameraLensDirection, this.excercise);

  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  String stage = "down", msg = "Posture incorrect";
  static int counter = 0;
  String excercise = "curl";

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(
        color: Colors.white,
        fontSize: 30,
        backgroundColor: Color.fromARGB(141, 0, 0, 0));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
            Offset(
              translateX(
                landmark.x,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
              translateY(
                landmark.y,
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
            ),
            1,
            paint);
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(
                translateX(
                  joint1.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint1.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            Offset(
                translateX(
                  joint2.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint2.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            paintType);
      }

      //Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          rightPaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          rightPaint);

      //Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

      calculate_angle(
          PoseLandmarkType start, PoseLandmarkType mid, PoseLandmarkType end) {
        final PoseLandmark joint1 = pose.landmarks[start]!;
        final PoseLandmark joint2 = pose.landmarks[mid]!;
        final PoseLandmark joint3 = pose.landmarks[end]!;

        List<double> first = [joint1.x, joint1.y];
        List<double> second = [joint2.x, joint2.y];
        List<double> third = [joint3.x, joint3.y];

        double radians = atan2(third[1] - second[1], third[0] - second[0]) -
            atan2(first[1] - second[1], first[0] - second[0]);
        double angle = (radians * 180.0 / pi).abs();

        return angle;
      }

      // Logic according to excercise

      switch (excercise) {
        case "squat":
          {
            var right_hip = PoseLandmarkType.rightHip;
            var right_knee = PoseLandmarkType.rightKnee;
            var right_ankle = PoseLandmarkType.rightAnkle;
            var angle =
                calculate_angle(right_hip, right_knee, right_ankle).toInt();
            if (angle > 160 && stage == "down") {
              stage = "up";
            } else if (angle < 30 && stage == "up") {
              stage = "down";
              counter += 1;
            }
            var textSpan = TextSpan(
              text: "Stage: ${stage}\nRight Knee Angle: ${angle}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "arm stretch right":
          {
            var right_shoulder = PoseLandmarkType.rightShoulder;
            var right_elbow = PoseLandmarkType.rightElbow;
            var right_wrist = PoseLandmarkType.rightWrist;
            var left_shoulder = PoseLandmarkType.leftShoulder;
            var left_elbow = PoseLandmarkType.leftElbow;
            var left_wrist = PoseLandmarkType.leftWrist;
            var left_index = pose.landmarks[PoseLandmarkType.leftAnkle]?.x;
            var right_index = pose.landmarks[PoseLandmarkType.rightAnkle]?.x;
            var right_shoulder_y =
                pose.landmarks[PoseLandmarkType.rightShoulder]?.y;
            var right_elbow_y = pose.landmarks[PoseLandmarkType.rightElbow]?.y;
            var right_wrist_y = pose.landmarks[PoseLandmarkType.rightWrist]?.y;

            // Right Arm Angle
            var angle =
                calculate_angle(right_shoulder, right_elbow, right_wrist)
                    .toInt();

            // Left Arm Angle
            var angle2 =
                calculate_angle(left_shoulder, left_elbow, left_wrist).toInt();

            if (angle > 100 &&
                angle < 200 &&
                angle2 > 240 &&
                left_index! - right_index! < 30) {
              if (right_wrist_y! < right_elbow_y! &&
                  right_elbow_y < right_shoulder_y! &&
                  stage == "down") {
                stage = "up";
                counter += 1;
              } else if ((right_wrist_y > right_elbow_y ||
                      right_elbow_y > right_shoulder_y!) &&
                  stage == "up") {
                stage = "down";
              }
            }

            var textSpan = TextSpan(
              text:
                  "Stage: ${stage}\nRight Arm Angle: ${angle}\nLeft Arm Angle: ${angle2}\nCounter: ${counter}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "arm stretch left":
          {
            var right_shoulder = PoseLandmarkType.rightShoulder;
            var right_elbow = PoseLandmarkType.rightElbow;
            var right_wrist = PoseLandmarkType.rightWrist;
            var left_shoulder = PoseLandmarkType.leftShoulder;
            var left_elbow = PoseLandmarkType.leftElbow;
            var left_wrist = PoseLandmarkType.leftWrist;
            var left_index = pose.landmarks[PoseLandmarkType.leftAnkle]?.x;
            var right_index = pose.landmarks[PoseLandmarkType.rightAnkle]?.x;
            var left_shoulder_y =
                pose.landmarks[PoseLandmarkType.leftShoulder]?.y;
            var left_elbow_y = pose.landmarks[PoseLandmarkType.leftElbow]?.y;
            var left_wrist_y = pose.landmarks[PoseLandmarkType.leftWrist]?.y;

            // Right Arm Angle
            var angle =
                calculate_angle(right_shoulder, right_elbow, right_wrist)
                    .toInt();

            // Left Arm Angle
            var angle2 =
                calculate_angle(left_shoulder, left_elbow, left_wrist).toInt();

            if (angle2 > 170 &&
                angle2 < 220 &&
                angle < 120 &&
                left_index! - right_index! < 30) {
              if (left_wrist_y! < left_elbow_y! &&
                  left_elbow_y < left_shoulder_y! &&
                  stage == "down") {
                stage = "up";
                counter += 1;
              } else if ((left_wrist_y > left_elbow_y ||
                      left_elbow_y > left_shoulder_y!) &&
                  stage == "up") {
                stage = "down";
              }
            }

            var textSpan = TextSpan(
              text:
                  "Stage: ${stage}\nRight Arm Angle: ${angle}\nLeft Arm Angle: ${angle2}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "cross toe touch":
          {
            var right_shoulder = PoseLandmarkType.rightShoulder;
            var right_hip = PoseLandmarkType.rightHip;
            var right_knee = PoseLandmarkType.rightKnee;
            var right_wrist = PoseLandmarkType.rightWrist;
            var right_elbow = PoseLandmarkType.rightElbow;

            var left_shoulder = PoseLandmarkType.leftShoulder;
            var left_hip = PoseLandmarkType.leftHip;
            var left_knee = PoseLandmarkType.leftKnee;
            var left_elbow = PoseLandmarkType.leftElbow;
            var left_wrist = PoseLandmarkType.leftWrist;

            var right_shoulder_y = pose.landmarks[right_shoulder]?.y;
            var right_elbow_y = pose.landmarks[right_elbow]?.y;
            var right_wrist_y = pose.landmarks[right_wrist]?.y;
            var right_hand_x =
                pose.landmarks[PoseLandmarkType.rightIndex]?.x.toInt();
            var right_hand_y =
                pose.landmarks[PoseLandmarkType.rightIndex]?.y.toInt();
            var right_knee_x = pose.landmarks[right_knee]?.x.toInt();
            var right_knee_y = pose.landmarks[right_knee]?.y.toInt();

            var left_shoulder_y = pose.landmarks[left_shoulder]?.y.toInt();
            var left_elbow_y = pose.landmarks[left_elbow]?.y.toInt();
            var left_wrist_y = pose.landmarks[left_wrist]?.y.toInt();
            var left_hand_x = pose.landmarks[PoseLandmarkType.leftIndex]?.x;
            var left_hand_y = pose.landmarks[PoseLandmarkType.leftIndex]?.y;
            var left_knee_x = pose.landmarks[left_knee]?.x;
            var left_knee_y = pose.landmarks[left_knee]?.y;

            var diff1 = (right_shoulder_y! - right_elbow_y!).abs().toInt();
            var diff2 = (right_elbow_y! - right_wrist_y!).abs().toInt();
            var diff3 = (left_shoulder_y! - left_elbow_y!).abs().toInt();
            var diff4 = (left_elbow_y! - left_wrist_y!).abs().toInt();
            var diff5 = (right_shoulder_y! - left_elbow_y!).abs().toInt();

            var angle =
                calculate_angle(right_shoulder, right_hip, right_knee).toInt();
            var angle2 =
                calculate_angle(left_shoulder, left_hip, left_knee).toInt();

            if (diff1 < 40 &&
                diff2 < 40 &&
                diff3 < 40 &&
                diff4 < 40 &&
                diff5 < 40 &&
                angle > 200 &&
                angle2 < 180 &&
                msg == "Posture incorrect") {
              msg = "Posture correct";
            } else if (left_wrist_y < left_elbow_y &&
                left_elbow_y < left_shoulder_y &&
                right_hand_x! - right_knee_x! < 200 &&
                right_hand_y! - right_knee_y! < 200) {
              msg =
                  "You are touching your left knee/toe. Now touch your right knee/toe";
            } else if (right_wrist_y < right_elbow_y &&
                right_elbow_y < right_shoulder_y &&
                left_hand_x! - left_knee_x! < 100 &&
                left_hand_y! - left_knee_y! < 100) {
              msg =
                  "You are touching your right knee/toe. Now touch your left knee/toe";
            } else {
              msg = "Posture incorrect";
            }
            var textSpan = TextSpan(
              text:
                  "Message: ${msg}\nRight Feet Angle: ${angle}\nLeft Feet Angle: ${angle2}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "lateral lunge right":
          {
            // stage = "up";
            var right_hip = PoseLandmarkType.rightHip;
            var right_knee = PoseLandmarkType.rightKnee;
            var right_ankle = PoseLandmarkType.rightAnkle;

            // Right Knee Angle
            var angle =
                calculate_angle(right_hip, right_knee, right_ankle).toInt();
            if (angle > 90 && angle < 140 && stage == "up") {
              stage = "down";
              counter += 1;
            } else if (angle > 140 && stage == "down") {
              stage = "up";
            }
            var textSpan = TextSpan(
              text: "Stage: ${stage}\nRight Knee Angle: ${angle}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "lateral lunge left":
          {
            // stage = "up";
            var left_hip = PoseLandmarkType.leftHip;
            var left_knee = PoseLandmarkType.leftKnee;
            var left_ankle = PoseLandmarkType.leftAnkle;

            // Left Knee Angle
            var angle =
                calculate_angle(left_hip, left_knee, left_ankle).toInt();
            if (angle > 230 && angle < 260 && stage == "up") {
              stage = "down";
              counter += 1;
            } else if (angle < 230 && stage == "down") {
              stage = "up";
            }
            var textSpan = TextSpan(
              text: "Stage: ${stage}\nLeft Knee Angle: ${angle}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "reverse lunge right":
          {
            // stage = "up";
            var left_hip = PoseLandmarkType.leftHip;
            var left_knee = PoseLandmarkType.leftKnee;
            var left_ankle = PoseLandmarkType.leftAnkle;
            var right_hip = PoseLandmarkType.rightHip;
            var right_knee = PoseLandmarkType.rightKnee;
            var right_ankle = PoseLandmarkType.rightAnkle;

            // Left Knee Angle
            var angle =
                calculate_angle(left_hip, left_knee, left_ankle).toInt();

            // Right Knee Angle
            var angle2 =
                calculate_angle(right_hip, right_knee, right_ankle).toInt();

            if (angle2 > 210 &&
                angle2 < 260 &&
                angle > 180 &&
                angle < 210 &&
                stage == "up") {
              stage = "down";
              counter += 1;
            } else if (angle2 < 210 && stage == "down") {
              stage = "up";
            }
            var textSpan = TextSpan(
              text:
                  "Stage: ${stage}\nLeft Knee Angle: ${angle}\nRight Knee Angle: ${angle2}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "reverse lunge left":
          {
            // stage = "up";
            var left_hip = PoseLandmarkType.leftHip;
            var left_knee = PoseLandmarkType.leftKnee;
            var left_ankle = PoseLandmarkType.leftAnkle;
            var right_hip = PoseLandmarkType.rightHip;
            var right_knee = PoseLandmarkType.rightKnee;
            var right_ankle = PoseLandmarkType.rightAnkle;

            // Left Knee Angle
            var angle =
                calculate_angle(left_hip, left_knee, left_ankle).toInt();

            // Right Knee Angle
            var angle2 =
                calculate_angle(right_hip, right_knee, right_ankle).toInt();

            if (angle2 > 200 &&
                angle2 < 210 &&
                angle > 200 &&
                angle < 230 &&
                stage == "up") {
              stage = "down";
              counter += 1;
            } else if (angle2 < 200 && stage == "down") {
              stage = "up";
            }
            var textSpan = TextSpan(
              text:
                  "Stage: ${stage}\nLeft Knee Angle: ${angle}\nRight Knee Angle: ${angle2}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "knee thrusters right":
          {
            var right_hip = PoseLandmarkType.rightHip;
            var right_knee = PoseLandmarkType.rightKnee;
            var right_ankle = PoseLandmarkType.rightAnkle;

            var left_shoulder = PoseLandmarkType.leftShoulder;
            var left_elbow = PoseLandmarkType.leftElbow;
            var left_wrist = PoseLandmarkType.leftWrist;
            var left_ankle = PoseLandmarkType.leftAnkle;

            var right_hand_x =
                pose.landmarks[PoseLandmarkType.rightIndex]?.x.toInt();
            var right_knee_x = pose.landmarks[right_knee]?.x.toInt();
            var right_ankle_x = pose.landmarks[right_ankle]?.x.toInt();

            var left_shoulder_y = pose.landmarks[left_shoulder]?.y.toInt();
            var left_elbow_y = pose.landmarks[left_elbow]?.y.toInt();
            var left_wrist_y = pose.landmarks[left_wrist]?.y.toInt();
            var left_hand_x = pose.landmarks[PoseLandmarkType.leftIndex]?.x;
            var left_ankle_x = pose.landmarks[left_ankle]?.x.toInt();

            var diff1 = (right_hand_x! - left_hand_x!).abs().toInt();
            var diff2 = (left_ankle_x! - right_ankle_x!).abs().toInt();
            var diff3 = (right_hand_x! - right_knee_x!).abs().toInt();
            var diff4 = (left_hand_x! - right_knee_x!).abs().toInt();

            // Right Knee Angle
            var angle =
                calculate_angle(right_hip, right_knee, right_ankle).toInt();

            if (left_wrist_y! < left_elbow_y! &&
                left_elbow_y < left_shoulder_y! &&
                diff1 < 50 &&
                diff2 > 50) {
              msg = "Posture up";
            } else if (angle < 100 && diff3 < 50 && diff4 < 50) {
              msg = "You are touching your right knee. Come back up.";
            } else {
              msg = "Posture neutral";
            }
            var textSpan = TextSpan(
              text:
                  "Message: ${msg}\nRight Knee Angle: ${angle}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "knee thrusters left":
          {
            var left_hip = PoseLandmarkType.leftHip;
            var left_knee = PoseLandmarkType.leftKnee;
            var left_ankle = PoseLandmarkType.leftAnkle;
            var left_shoulder = PoseLandmarkType.leftShoulder;
            var left_elbow = PoseLandmarkType.leftElbow;
            var left_wrist = PoseLandmarkType.leftWrist;

            var right_ankle = PoseLandmarkType.rightAnkle;

            var right_hand_x =
                pose.landmarks[PoseLandmarkType.rightIndex]?.x.toInt();
            var right_ankle_x = pose.landmarks[right_ankle]?.x.toInt();

            var left_shoulder_y = pose.landmarks[left_shoulder]?.y.toInt();
            var left_elbow_y = pose.landmarks[left_elbow]?.y.toInt();
            var left_wrist_y = pose.landmarks[left_wrist]?.y.toInt();
            var left_hand_x = pose.landmarks[PoseLandmarkType.leftIndex]?.x;
            var left_ankle_x = pose.landmarks[left_ankle]?.x.toInt();
            var left_knee_x = pose.landmarks[left_knee]?.x.toInt();

            var diff1 = (right_hand_x! - left_hand_x!).abs().toInt();
            var diff2 = (left_ankle_x! - right_ankle_x!).abs().toInt();
            var diff3 = (right_hand_x! - left_knee_x!).abs().toInt();
            var diff4 = (left_hand_x! - left_knee_x!).abs().toInt();

            // Left Knee Angle
            var angle =
                calculate_angle(left_hip, left_knee, left_ankle).toInt();

            if (left_wrist_y! < left_elbow_y! &&
                left_elbow_y < left_shoulder_y! &&
                diff1 < 50 &&
                diff2 > 50) {
              msg = "Posture up";
            } else if (angle < 100 && diff3 < 50 && diff4 < 50) {
              msg = "You are touching your left knee. Come back up.";
            } else {
              msg = "Posture neutral";
            }
            var textSpan = TextSpan(
              text:
                  "Message: ${msg}\nLeft Knee Angle: ${angle}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
        case "bird pose right":
          {
            msg = "Posture Neutral";
            var right_hip = PoseLandmarkType.rightHip;

            var left_knee = PoseLandmarkType.leftKnee;

            var right_hip_y = pose.landmarks[right_hip]?.y;
            var right_hand_y =
                pose.landmarks[PoseLandmarkType.rightIndex]?.y.toInt();
            var right_foot_y =
                pose.landmarks[PoseLandmarkType.rightFootIndex]?.y.toInt();

            var left_knee_y = pose.landmarks[left_knee]?.y.toInt();
            var left_hand_y = pose.landmarks[PoseLandmarkType.leftIndex]?.y;
            
            var diff1 = (left_hand_y! - right_hip_y!).abs().toInt();
            var diff2 = (right_hip_y! - right_foot_y!).abs().toInt();
            var diff3 = (left_knee_y! - right_hand_y!).abs().toInt();

            if (diff1 < 80 &&
                diff2 < 80 &&
                diff3 < 80 &&
                msg == "Posture Neutral") {
              msg = "Bird Pose Right";
            } else if (msg == "Bird Pose") {
              msg = "Posture Neutral";
            }
            var textSpan = TextSpan(
              text:
                  "Message: ${msg}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
          case "bird pose left":
          {
            msg = "Posture Neutral";
            var left_hip = PoseLandmarkType.leftHip;

            var right_knee = PoseLandmarkType.rightKnee;

            var left_hip_y = pose.landmarks[left_hip]?.y;
            var left_hand_y =
                pose.landmarks[PoseLandmarkType.leftIndex]?.y.toInt();
            var left_foot_y =
                pose.landmarks[PoseLandmarkType.leftFootIndex]?.y.toInt();

            var right_knee_y = pose.landmarks[right_knee]?.y.toInt();
            var right_hand_y = pose.landmarks[PoseLandmarkType.rightIndex]?.y;
            
            var diff1 = (right_hand_y! - left_hip_y!).abs().toInt();
            var diff2 = (left_hip_y! - left_foot_y!).abs().toInt();
            var diff3 = (right_knee_y! - left_hand_y!).abs().toInt();

            if (diff1 < 80 &&
                diff2 < 80 &&
                diff3 < 80 &&
                msg == "Posture Neutral") {
              msg = "Bird Pose Left";
            } else if (msg == "Bird Pose") {
              msg = "Posture Neutral";
            }
            var textSpan = TextSpan(
              text:
                  "Message: ${msg}",
              style: textStyle,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
            );
            final xCenter = (size.width - textPainter.width) / 2;
            final yCenter = (size.height - textPainter.height);
            final offset = Offset(xCenter, yCenter);
            textPainter.paint(canvas, offset);
          }
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}
