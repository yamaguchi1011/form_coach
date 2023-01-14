
# 初期設定
# csvで出力したければ使用する（出力方法は別で調べる）
import csv

# from tkinter import font
# from turtle import right
import mediapipe as mp
import numpy as np
import subprocess
import os
import shutil
import cv2
import glob

mp_pose = mp.solutions.pose

# Initialize MediaPipe pose.
pose = mp_pose.Pose(
    static_image_mode=True, min_detection_confidence=0.5)

# Prepare DrawingSpec for drawing the face landmarks later.
mp_drawing = mp.solutions.drawing_utils 
drawing_spec = mp_drawing.DrawingSpec(thickness=1, circle_radius=1)

# サンプルビデオの読み込み＋静止画に分解

# ビデオの指定
video_path = './video/test2.mp4'
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
 
def main():
    video_2_images()
    
if __name__ == '__main__':
    main()

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
    
    # if angle >180.0:
    #     angle = 360-angle
        
    return angle 

# imagesフォルダにあるimage（xxxxxx.png）に対して姿勢推定処理をしてランドマークと点を描画し、それをimageがあるだけ繰り返す。
for name, image in images.items():
  # Convert the BGR image to RGB and process it with MediaPipe Pose.
  results = pose.process(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
  # Draw pose landmarks.
  annotated_image = image.copy()
  # 画像が不鮮明で、座標を取得できない場合はエラーになるので、try文とpass文を使って、例外が出たら何もしないようにする。
  try:
    # 角度描画のための定義(ここで３点とxyz座標の変えたら色々な角度が出せる)
    left_shoulder = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_SHOULDER.value].z
    right_shoulder = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].z
    right_elbow = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_ELBOW.value].z
    angle = calculate_angle(left_shoulder, right_shoulder, right_elbow)
     # 角度を画像内に描画
    cv2.putText(annotated_image, 
                            text='angle', 
                            org=(100,50), 
                            fontFace=cv2.FONT_HERSHEY_SIMPLEX,
                            fontScale=1.0,
                            color=(0,255,0),
                            thickness=2,
                            lineType=cv2.LINE_4)    
    cv2.putText(annotated_image, 
                            text=str(angle), 
                            org=(100,100), 
                            fontFace=cv2.FONT_HERSHEY_SCRIPT_SIMPLEX,
                            fontScale=1.0,
                            color=(0,255,0),
                            thickness=2,
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
if os.path.exists('./output.mp4'):
    os.remove('./output.mp4')

subprocess.call('ffmpeg -r 10 -i images/%06d.png -vcodec libx264 -pix_fmt yuv420p output.mp4', shell=True)




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
