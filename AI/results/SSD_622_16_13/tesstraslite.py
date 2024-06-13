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


interpreter = tf.lite.Interpreter(model_path="F:\Study\PBL5\SSD\SSDtrain\SSD_622_16_13\\flite_13\model.tflite")
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Các hàm inference

import cv2

def preprocess_image(image):

    image = image.astype(np.float32) / 255.0
    return image

def run_inference_for_single_image(interpreter, image):
    # Preprocess the input image
    image = cv2.resize(image, (input_details[0]['shape'][2], input_details[0]['shape'][1]))
    image = np.expand_dims(image, axis=0)

    interpreter.set_tensor(input_details[0]['index'], image)

    interpreter.invoke()

    # Get outputs
    output_dict = {}
    for i in range(len(output_details)):
        output_data = interpreter.get_tensor(output_details[i]['index'])
        output_dict[output_details[i]['name']] = output_data

    return output_dict

def load_image_into_numpy_array(path):
    img_data = tf.io.gfile.GFile(path, 'rb').read()
    image = Image.open(BytesIO(img_data))
    (im_width, im_height) = image.size
    return np.array(image.getdata()).reshape((im_height, im_width, 3)).astype(np.uint8)

def xuli(image_path):
  image_np = load_image_into_numpy_array(image_path)
  print("Done load image: {} ". format(image_path))
  image_np = cv2.resize(image_np, dsize=None, fx=0.3, fy=0.3)
  image_np = preprocess_image(image_np)
  output_dict = run_inference_for_single_image(interpreter, image_np)
  print("Done inference")


  max_score_index = np.argmax(output_dict['StatefulPartitionedCall:1'])

  max_score_box = output_dict['StatefulPartitionedCall:3'][0][max_score_index]


  max_score_class_id = (output_dict['StatefulPartitionedCall:2'][0][max_score_index] + 1).astype(np.int64)


  max_score_class = category_index[max_score_class_id]['name']

#   print("max_score_index: {}, max_score_box: {}, max_score_class_id: {}, max_score_class: {} ".format(max_score_index, max_score_box, max_score_class_id, max_score_class))

  max_score = output_dict['StatefulPartitionedCall:1'][0][max_score_index]

  print("Class: {}, Score: {}".format(max_score_class, max_score))


  vis_util.visualize_boxes_and_labels_on_image_array(
      image_np,
      np.array([max_score_box]),  # Sử dụng box của phần tử có điểm số cao nhất
      np.array([max_score_class_id]),  # Sử dụng class ID của phần tử có điểm số cao nhất
      np.array([output_dict['StatefulPartitionedCall:1'][0][max_score_index]]),  # Sử dụng điểm số của phần tử có điểm số cao nhất
      category_index,
      use_normalized_coordinates=True,
      line_thickness=5
  )

  line_thickness=5
  
  print("Done draw on image ")
  image_np = image_np.astype(np.uint8)

  display(Image.fromarray(image_np))
  return max_score_class

# Path to label map file
label_map_path = "F:\Study\PBL5\SSD\SSDtrain\images\label_map.txt"
category_index = label_map_util.create_category_index_from_labelmap(label_map_path, use_display_name=True)

image_path = 'F:\Study\PBL5\SSD\darkdata\\020000_11.jpg'
money=xuli(image_path)
print(money)

convert_to_audio(money)