# -*- coding: utf-8 -*-
# 初期設定
# csvで出力したければ使用する（出力方法は別で調べる）
import csv
import subprocess
# from tkinter import font
# from turtle import right
import mediapipe as mp
import numpy as np
import os
import shutil
import cv2
import glob

import sys
from decimal import *
mp_pose = mp.solutions.pose

# Initialize MediaPipe pose.
pose = mp_pose.Pose(
    static_image_mode=True, min_detection_confidence=0.5)

# Prepare DrawingSpec for drawing the face landmarks later.
mp_drawing = mp.solutions.drawing_utils 
drawing_spec = mp_drawing.DrawingSpec(thickness=1, circle_radius=1)

# サンプルビデオの読み込み＋静止画に分解

# ビデオの指定

video_path = sys.argv[1]
dominant_arm = sys.argv[2]

# 絶対パス　/Users/yamaguchitakashi/form_coach/video/test2.mp4
# video2images


# 既にimagesフォルダーがあれば削除
if os.path.isdir('images'):
   shutil.rmtree('images')

os.makedirs('images', exist_ok=True)
 
def video_2_images(video_file= video_path,   
                   image_dir='./images/', 
                   image_file='%s.png'):
 
    # Initial setting
    i = 0
    interval = 3
    length = 300
    
    cap = cv2.VideoCapture(video_file)
    while(cap.isOpened()):
        flag, frame = cap.read()  
        if flag == False:  
                break
        if i == length*interval:
                break
        if i % interval == 0:    
           cv2.imwrite(image_dir+image_file % str(int(i/interval)).zfill(6), frame)
        i += 1 
    cap.release()  
video_2_images() 

# # MediaPipeで静止画を処理

# import cv2
# from google.colab.patches import cv2_imshow
# import numpy as np


# image file names to files in list format
files=[]
for name in sorted(glob.glob('./images/*.png')):
    files.append(name)

# Read images with OpenCV.
images = {name: cv2.imread(name) for name in files}

def fields_name():
    # CSVのヘッダを準備
    fields = []
    fields.append('file_name')
    for i in range(33):
        fields.append(str(i)+'_x')
        fields.append(str(i)+'_y')
        fields.append(str(i)+'_z')
    return fields

# 角度計算
def calculate_angle(a,b,c):
    a = np.array(a) # First
    b = np.array(b) # Mid
    c = np.array(c) # End
    
    radians = np.arctan2(c[1]-b[1], c[0]-b[0]) - np.arctan2(a[1]-b[1], a[0]-b[0])
    angle = np.abs(radians*180.0/np.pi)
    d1 = Decimal(angle)
    angle_round = d1.quantize(Decimal('0'),rounding=ROUND_HALF_UP)
    # if angle >180.0:
    #     angle = 360-angle
        
    return angle_round 
# フォルダの中の一番最後から３０枚までの画像は大体はフォロースルーの状態のなので肘の危険の判断をしないためにフォルダ内の最後の画像ファイルを取得する。
# imagesフォルダにある画像ファイルを順番に並べて配列として取得する。
images_dir = sorted(glob.glob("./images/*"))
# 配列の一番最後を取得する。
last_dir = images_dir[-1]
# 取得した一番最後のファイル名を分解して数字のみ取り出し、データ型を整数にして、３０を引く（後ろから３０番目までを表すため）
last_dir_number = int(os.path.splitext(os.path.basename(last_dir))[0]) -30
# imagesフォルダにあるimage（xxxxxx.png）に対して姿勢推定処理をしてランドマークと点を描画し、それをimageがあるだけ繰り返す。

# 右投げと左投げで取得する座標が違うのでifで分岐させる
#右投げの場合ここから
if dominant_arm == "右":
  for name, image in images.items():
    # Convert the BGR image to RGB and process it with MediaPipe Pose.
    results = pose.process(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
    # Draw pose landmarks.
    annotated_image = image.copy()
    # 画像が不鮮明で、座標を取得できない場合はエラーになるので、try文とpass文を使って、例外が出たら何もしないようにする。
    try:
      # 角度描画のための定義(ここで３点とxyz座標を変えたら色々な角度が出せる)
      left_shoulder = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z
      right_shoulder = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z
      right_elbow = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_ELBOW.value].z
      angle = calculate_angle(left_shoulder, right_shoulder, right_elbow)
      # x座標の値が投げ手側手首≧投げ手側肘≧投げ手側肩の順番になった時の左肩、右肩、右肘の角度が170度以下なら肘が危険と判断する。そのために各x座標を取得する。
      right_shoulder_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x
      right_elbow_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x
      right_wrist_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_WRIST.value].x
      # 踏み出し足首、踏み出し膝、踏み出し股関節、軸足股関節、軸足膝、軸足首の順にx座標の値が並んだら開脚していると判断するために各x座標を取得する。
      left_ankle_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_ANKLE.value].x
      left_knee_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_KNEE.value].x
      left_hip_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_HIP.value].x
      right_ankle_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_ANKLE.value].x
      right_knee_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_KNEE.value].x
      right_hip_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_HIP.value].x
      # 開脚の判定を変数に入れる
      spread_legs = right_ankle_x < right_knee_x < right_hip_x < left_hip_x < left_knee_x < left_ankle_x 

      # 投球の一番最初の瞬間に,肘が危険どうかを判断する条件を満たしてしまう場合があるので画像の順番をファイル名から取ってきて分析のスタートは000030.png以上からにする。
      start_file_number = 45
      # ファイル名とってきて整数に変換する。
      name_file_number = int(os.path.splitext(os.path.basename(name))[0]) 
      # フォルダの中の一番最後から３０枚までの画像は大体はフォロースルーの状態なので肘の危険判定には含めない
      
      # ①座標の値が投げ手側肩≦投げ手側手首≦投げ手側肘の順番になった時かつ、
      # ②画像のファイル名が000045.png以上、最後から数えて３０番目まで（フォルダの中の一番最後から３０枚までの画像は大体はフォロースルーの状態のため危険度判定に含めたくない）かつ、
      # ③踏み出し足首、踏み出し膝、踏み出し股関節、軸足股関節、軸足膝、軸足首の順にx座標の値が並んだ時に、
      # ④左肩、右肩、右肘の角度が170度以下なら
      # 肘が危険と判断する。
      if right_shoulder_x <= right_wrist_x <= right_elbow_x and start_file_number <= name_file_number <= last_dir_number and spread_legs and angle <= 170 :
        cv2.putText(img=annotated_image, 
                                text='DANGER', 
                                org=(100,100), 
                                fontFace=cv2.FONT_HERSHEY_SIMPLEX,
                                fontScale=4.0,
                                color=(0,0,255),
                                thickness=9,
                                lineType=cv2.LINE_4)    
        
        cv2.putText(annotated_image, 
                                text=str(angle), 
                                org=(100,180), 
                                fontFace=cv2.FONT_HERSHEY_SCRIPT_SIMPLEX,
                                fontScale=3.0,
                                color=(0,0,255),
                                thickness=8,
                                lineType=cv2.LINE_4)     
      else:

        # 角度を画像内に描画
        cv2.putText(annotated_image, 
                                text='SAFETY', 
                                org=(100,100), 
                                fontFace=cv2.FONT_HERSHEY_SIMPLEX,
                                fontScale=3.5,
                                color=(0,255,0),
                                thickness=7,
                                lineType=cv2.LINE_4)    
        cv2.putText(annotated_image, 
                                text=str(angle), 
                                org=(100,180), 
                                fontFace=cv2.FONT_HERSHEY_SCRIPT_SIMPLEX,
                                fontScale=3.0,
                                color=(0,255,0),
                                thickness=6,
                                lineType=cv2.LINE_4)  
    except:
      pass
    # 画像に各ランドマークとそれを繋げる線を描画する
    mp_drawing.draw_landmarks(
        image=annotated_image, 
        landmark_list=results.pose_landmarks, 
        connections=mp_pose.POSE_CONNECTIONS,
        # 描画の色設定
        landmark_drawing_spec=mp_drawing.DrawingSpec(color=(245,117,66), thickness=2, circle_radius=2),
        connection_drawing_spec=mp_drawing.DrawingSpec(color=(245,66,230), thickness=2, circle_radius=2))
    # 処理した画像を保存する
    cv2.imwrite(name, annotated_image)  
  # 画像の名前と、角度を取ってこれる。
  # print(name,angle)
# 右投げの場合ここまで
# 左投げの場合ここから
else:
  for name, image in images.items():
    # Convert the BGR image to RGB and process it with MediaPipe Pose.
    results = pose.process(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
    # Draw pose landmarks.
    annotated_image = image.copy()
    # 画像が不鮮明で、座標を取得できない場合はエラーになるので、try文とpass文を使って、例外が出たら何もしないようにする。
    try:
      # 角度描画のための定義(ここで３点とxyz座標の変えたら色々な角度が出せる)
      right_shoulder = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z
      left_shoulder = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z
      left_elbow = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_ELBOW.value].z
      angle = calculate_angle(right_shoulder, left_shoulder, left_elbow)
      # x座標の値が投げ手側手首≧投げ手側肘≧投げ手側肩の順番になった時の左肩、右肩、右肘の角度が170度以下なら肘が危険と判断する。そのためにx座標を定義する。
      left_shoulder_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x
      left_elbow_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_ELBOW.value].x
      left_wrist_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_WRIST.value].x
       # 踏み出し足首、踏み出し膝、踏み出し股関節、軸足股関節、軸足膝、軸足首の順にx座標の値が並んだら開脚していると判断するために各x座標を取得する。
      left_ankle_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_ANKLE.value].x
      left_knee_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_KNEE.value].x
      left_hip_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_HIP.value].x
      right_ankle_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_ANKLE.value].x
      right_knee_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_KNEE.value].x
      right_hip_x = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_HIP.value].x
      # 開脚の判定を変数に入れる
      spread_legs = right_ankle_x < right_knee_x < right_hip_x < left_hip_x < left_knee_x < left_ankle_x 
      # spread_legs = left_ankle_x < left_knee_x < left_hip_x < right_hip_x < right_knee_x < right_ankle_x 
      # 投球の一番最初の瞬間に,肘が危険どうかを判断する条件を満たしてしまう場合があるので画像の順番をファイル名から取ってきて分析のスタートは000030.png以上からにする。
      start_file_number = 45
      # ファイル名とってきて整数に変換する。
      name_file_number = int(os.path.splitext(os.path.basename(name))[0]) 
      # フォルダの中の一番最後から３０枚までの画像は大体はフォロースルーの状態のなので肘の危険
      
      # ①座標の値が投げ手側肘≦投げ手側手首≦投げ手側肩の順番になった時かつ、
      # ②画像のファイル名が000045.png以上、最後から数えて３０番目まで（フォルダの中の一番最後から３０枚までの画像は大体はフォロースルーの状態のため危険度判定に含めたくない）で、
      # ③踏み出し足首、踏み出し膝、踏み出し股関節、軸足股関節、軸足膝、軸足首の順にx座標の値が並んだ時に、
      # ④左肩、右肩、右肘の角度が170度以下なら
      # 肘が危険だと判断する。
      if left_elbow_x <= left_wrist_x <= left_shoulder_x and start_file_number <= name_file_number <= last_dir_number and spread_legs and angle <= 170 :
        cv2.putText(img=annotated_image, 
                                text='DANGER', 
                                org=(100,100), 
                                fontFace=cv2.FONT_HERSHEY_SIMPLEX,
                                fontScale=4.0,
                                color=(0,0,255),
                                thickness=9,
                                lineType=cv2.LINE_4)    
        
        cv2.putText(annotated_image, 
                                text=str(angle), 
                                org=(100,180), 
                                fontFace=cv2.FONT_HERSHEY_SCRIPT_SIMPLEX,
                                fontScale=3.0,
                                color=(0,0,255),
                                thickness=8,
                                lineType=cv2.LINE_4)     
      else:

        # 角度を画像内に描画
        cv2.putText(annotated_image, 
                                text='SAFETY', 
                                org=(100,100), 
                                fontFace=cv2.FONT_HERSHEY_SIMPLEX,
                                fontScale=3.5,
                                color=(0,255,0),
                                thickness=7,
                                lineType=cv2.LINE_4)    
        cv2.putText(annotated_image, 
                                text=str(angle), 
                                org=(100,180), 
                                fontFace=cv2.FONT_HERSHEY_SCRIPT_SIMPLEX,
                                fontScale=3.0,
                                color=(0,255,0),
                                thickness=6,
                                lineType=cv2.LINE_4)  
    except:
      pass
    # 画像に各ランドマークとそれを繋げる線を描画する
    mp_drawing.draw_landmarks(
        image=annotated_image, 
        landmark_list=results.pose_landmarks, 
        connections=mp_pose.POSE_CONNECTIONS,
        # 描画の色設定
        landmark_drawing_spec=mp_drawing.DrawingSpec(color=(245,117,66), thickness=2, circle_radius=2),
        connection_drawing_spec=mp_drawing.DrawingSpec(color=(245,66,230), thickness=2, circle_radius=2))
    # 処理した画像を保存する
    cv2.imwrite(name, annotated_image)  
# 左投げの場合ここまで



#   試しに出力するならコメントアウトを外す
  # 写真の名前と、写真の画像データをとってこれる 
  # print(name, annotated_image)

  # すべての写真に対してランドマークの番号１２の値をとってこれる
  # print(results.pose_landmarks.landmark[12])

  # 一枚の画像に対してposeの場合は32個のランドマーク（座標）があり、すべての画像に対して全てのランドマークの値を取ってこれる。
  # print(results.pose_landmarks.landmark)

  # save_csv_dir = './result/csv'
  # os.makedirs(save_csv_dir, exist_ok=True)
  # save_csv_name = 'landmark.csv'
  # with open(os.path.join(save_csv_dir, save_csv_name), 
  #           'w', encoding='utf-8', newline="") as f:

  #       # csv writer の用意
  #       writer = csv.DictWriter(f, fieldnames=fields_name())
  #       writer.writeheader()

        
  #       landmarks = results.pose_landmarks
  #    # CSVに書き込み
  #       record = {}
  #       record["file_name"] = os.path.basename(name)
  #       for i, landmark in enumerate(landmarks.landmark):
  #           record[str(i) + '_x'] = landmark.x
  #           record[str(i) + '_y'] = landmark.y
  #           record[str(i) + '_z'] = landmark.z
  #       writer.writerow(record)



# 処理した画像をmp4動画に変換
# 既に output.mp4 があれば削除

if os.path.exists(video_path):
    os.remove(video_path)


subprocess.call('ffmpeg-6.0-amd64-static/ffmpeg -r 10 -i images/%06d.png -vcodec libx264 -pix_fmt yuv420p {path}'.format(path=video_path), shell=True)


# def fields_name():
#     # CSVのヘッダを準備
#     fields = []
#     fields.append('file_name')
#     for i in range(21):
#         fields.append(str(i)+'_x')
#         fields.append(str(i)+'_y')
#         fields.append(str(i)+'_z')
#     return fields

# if __name__ == '__main__':
#     # 元の画像ファイルの保存先を準備
#     resource_dir = r'./data'
#     # 対象画像の一覧を取得
#     file_list = glob.glob(os.path.join(resource_dir, "*.png"))

#     # 保存先の用意
#     save_csv_dir = './result/csv'
#     os.makedirs(save_csv_dir, exist_ok=True)
#     save_csv_name = 'landmark.csv'
#     save_image_dir = 'result/image'
#     os.makedirs(save_image_dir, exist_ok=True)

#     with mp_pose.Pose(static_image_mode=True,
#             min_detection_confidence=0.5) as pose, \
#         open(os.path.join(save_csv_dir, save_csv_name), 
#             'w', encoding='utf-8', newline="") as f:

#         # csv writer の用意
#         writer = csv.DictWriter(f, fieldnames=fields_name())
#         writer.writeheader()

#         for file_path in file_list:
#             # 画像の読み込み
#             image = cv2.imread(file_path)

#             # 鏡写しの状態で処理を行うため反転
#             image = cv2.flip(image, 1)

#             # OpenCVとMediaPipeでRGBの並びが違うため、
#             # 処理前に変換しておく。
#             # CV2:BGR → MediaPipe:RGB
#             image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
#             image.flags.writeable = False

#             # 推論処理
#             results = pose.process(image)

#             # 前処理の変換を戻しておく。
#             image.flags.writeable = True
#             image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

#             if not results.pose_landmarks:
#                 # 検出できなかった場合はcontinue
#                 continue

#             # ランドマークの座標情報
#             landmarks = results.pose_landmarks[0]

#             # CSVに書き込み
#             record = {}
#             record["file_name"] = os.path.basename(file_path)
#             for i, landmark in enumerate(landmarks.landmark):
#                 record[str(i) + '_x'] = landmark.x
#                 record[str(i) + '_y'] = landmark.y
#                 record[str(i) + '_z'] = landmark.z
#             writer.writerow(record)
