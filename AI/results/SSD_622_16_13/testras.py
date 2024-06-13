# import subprocess
# from datetime import datetime

# # Định dạng tên file
# filename_format = "%Y%m%d_%H%M%S.jpg"

# # Lấy thời gian hiện tại
# current_time = datetime.now()

# # Tạo tên file từ thời gian hiện tại
# filename = current_time.strftime(filename_format)

# # Lệnh raspistill để chụp ảnh
# capture_command = "libcamera-still -o " + filename
# subprocess.run(capture_command, shell=True)  # Chụp ảnh


# from IPython.display import Audio

# def convert_to_audio(money_label):
#     audio_files = {
#         "1000": "D:\\a_ssdmobilenet\\RASP_AI\\VOICE\\1k.mp3",
#         "2000": "D:\\a_ssdmobilenet\\RASP_AI\\VOICE\\2k.mp3",
#         "5000": "D:\\a_ssdmobilenet\\RASP_AI\\VOICE\\5k.mp3",
#         "10000": "D:\\a_ssdmobilenet\\RASP_AI\\VOICE\\10k.mp3",
#         "20000": "D:\\a_ssdmobilenet\\RASP_AI\\VOICE\\20k.mp3",
#         "50000": "D:\\a_ssdmobilenet\\RASP_AI\\VOICE\\50k.mp3",
#         "100000": "D:\\a_ssdmobilenet\\RASP_AI\\VOICE\\100k.mp3",
#         "200000": "D:\\a_ssdmobilenet\\RASP_AI\\VOICE\\200k.mp3",
#         "500000": "D:\\a_ssdmobilenet\\RASP_AI\\VOICE\\500k.mp3",
#     }
    
#     if money_label in audio_files:
#         audio_path = audio_files[money_label]
#         display(Audio(audio_path, autoplay=True))
#     else:
#         print("Không có âm thanh cho mệnh giá này.")


# pip install playsound
from playsound import playsound

def convert_to_audio(money_label):
    audio_files = {
        "1000": "F:\Study\PBL5\SSD\SSDtrain\VOICE\\1k.mp3",
        "2000": "F:\Study\PBL5\SSD\SSDtrain\VOICE\\2k.mp3",
        "5000": "F:\Study\PBL5\SSD\SSDtrain\VOICE\\5k.mp3",
        "10000": "F:\Study\PBL5\SSD\SSDtrain\VOICE\\10k.mp3",
        "20000": "F:\Study\PBL5\SSD\SSDtrain\VOICE\\20k.mp3",
        "50000": "F:\Study\PBL5\SSD\SSDtrain\VOICE\\50k.mp3",
        "100000": "F:\Study\PBL5\SSD\SSDtrain\VOICE\\100k.mp3",
        "200000": "F:\Study\PBL5\SSD\SSDtrain\VOICE\\200k.mp3",
        "500000": "F:\Study\PBL5\SSD\SSDtrain\VOICE\\500k.mp3",

    }
    
    if money_label in audio_files:
        audio_path = audio_files[money_label]
        playsound(audio_path)
    else:
        print("Không có âm thanh cho mệnh giá này.")

import io
import os
import scipy.misc
import numpy as np
import six
import time
import glob
from IPython.display import display

from six import BytesIO

import matplotlib
import matplotlib.pyplot as plt
from PIL import Image, ImageDraw, ImageFont

import tensorflow as tf
# %cd /content/gdrive/MyDrive/MY_SSD/models/research
from object_detection.utils import ops as utils_ops
from object_detection.utils import label_map_util
from object_detection.utils import visualization_utils as vis_util

#Load model
tf.keras.backend.clear_session()
model = tf.saved_model.load("F:\Study\PBL5\SSD\SSDtrain\SSD_622_16_13\export_model\saved_model")
# Các hàm inference

import cv2
def run_inference_for_single_image(model, image):
  
  image = np.asarray(image)
  input_tensor = tf.convert_to_tensor(image)
  input_tensor = input_tensor[tf.newaxis,...]

  model_fn = model.signatures['serving_default']
  output_dict = model_fn(input_tensor)

  num_detections = int(output_dict.pop('num_detections'))
  output_dict = {key:value[0, :num_detections].numpy() 
                 for key,value in output_dict.items()}
  output_dict['num_detections'] = num_detections
  output_dict['detection_classes'] = output_dict['detection_classes'].astype(np.int64)
   
  if 'detection_masks' in output_dict:
    detection_masks_reframed = utils_ops.reframe_box_masks_to_image_masks(
              output_dict['detection_masks'], output_dict['detection_boxes'],
               image.shape[0], image.shape[1])      
    detection_masks_reframed = tf.cast(detection_masks_reframed > 0.5,
                                       tf.uint8)
    output_dict['detection_masks_reframed'] = detection_masks_reframed.numpy()
    
  return output_dict

def load_image_into_numpy_array(path):
  img_data = tf.io.gfile.GFile(path, 'rb').read()
  image = Image.open(BytesIO(img_data))
  (im_width, im_height) = image.size
  return np.array(image.getdata()).reshape(
      (im_height, im_width, 3)).astype(np.uint8)

def xuLy(image_path):
  image_np = load_image_into_numpy_array(image_path)
  # print("Done load image ")
  image_np = cv2.resize(image_np, dsize=None, fx=0.3, fy=0.3)

  output_dict = run_inference_for_single_image(model, image_np)
  # print("Done inference")

  vis_util.visualize_boxes_and_labels_on_image_array(
      image_np,
      output_dict['detection_boxes'],
      output_dict['detection_classes'],
      output_dict['detection_scores'],
      category_index,
      instance_masks=output_dict.get('detection_masks_reframed', None),
      use_normalized_coordinates=True,
      line_thickness=8)
  # print("Done draw on image ")

  #lấy ra kết quả cuối cùng
  first_detection_id = output_dict['detection_classes'][0]
  first_detection_label = category_index[first_detection_id]['name']
  print(output_dict['detection_classes'])
  print("Detect Money: {}".format(first_detection_label))
  print("Mark: {}".format(output_dict['detection_scores'][0]))
  display(Image.fromarray(image_np))
  print("\n")
  return first_detection_label

import os

# folder_path = '/content/gdrive/MyDrive/datatest'

category_index = label_map_util.create_category_index_from_labelmap("F:\Study\PBL5\SSD\SSDtrain\images\label_map.txt", use_display_name=True)

# for filename in os.listdir(folder_path):
#     # Kiểm tra nếu tệp là tệp CSV
#     if filename.endswith('jpg'):
#         file_path = os.path.join(folder_path, filename)
#         xuLy(file_path)
# file_path = '/content/gdrive/MyDrive/datatest/100000_1.jpg'
file_path = 'F:\Study\PBL5\SSD\SSDtrain\datatest\\1k_1.jpg'
money = xuLy(file_path)
print(money)


convert_to_audio(money)