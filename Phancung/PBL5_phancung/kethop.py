import RPi.GPIO as GPIO
import time
import subprocess
import pygame.mixer
import tensorflow as tf
import cv2
from datetime import datetime
from playsound import playsound
from object_detection.utils import ops as utils_ops
from object_detection.utils import label_map_util
from object_detection.utils import visualization_utils as vis_util
from PIL import Image, ImageDraw, ImageFont
from six import BytesIO
import numpy as np

ALARM_SOUND_st = "/home/pi/Desktop/VOICE/hethongkhoidong.mp3"
ALARM_SOUND_BD = "/home/pi/Desktop/VOICE/vatcan/vatcan_khoidong.mp3"
ALARM_SOUND_KT = "/home/pi/Desktop/VOICE/vatcan/vatcan_tat.mp3"
ALARM_SOUND_TIEN_BD = "/home/pi/Desktop/VOICE/tien/tien_khoidong.mp3"
ALARM_SOUND_TIEN_KT = "/home/pi/Desktop/VOICE/tien/tien_tat.mp3"

print("start")
def alarm(sound_file):
    pygame.mixer.init()
    pygame.mixer.music.load(sound_file)
    pygame.mixer.music.play()
    

interpreter = None

def load_model(model_path):
    global interpreter
    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    return interpreter

# Load model khi chương trình bắt đầu
interpreter = load_model("/home/pi/CodeAI/flite_15_4500/model.tflite")
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
print(input_details)
print(output_details)
print("done load")

alarm(ALARM_SOUND_st)

category_index = {
    1: {'name':'1000'},
    2: {'name':'2000'},
    3: {'name':'5000'},
    4: {'name':'10000'},
    5: {'name':'20000'},
    6: {'name':'50000'},
    7: {'name':'100000'},
    8: {'name':'200000'},
    9: {'name':'500000'},
}

def alarm(sound_file):
    pygame.mixer.init()
    pygame.mixer.music.load(sound_file)
    pygame.mixer.music.play()

def capture_image():
    filename_format = "%Y%m%d_%H%M%S.jpg"
    current_time = datetime.now()
    imgname = current_time.strftime(filename_format)
    filename = "/home/pi/CodeAI/img/" + imgname
    #capture_command = "libcamera-still -o /home/pi/CodeAI/img/" + filename
    capture_command = "libcamera-still -o " + filename
    subprocess.run(capture_command, shell=True)
    playsound('/home/pi/CodeAI/VOICE/tien/tien_xuli.mp3')
    return filename, imgname

def convert_to_audio(money_label, score):
    audio_files = {
        "1000": "/home/pi/CodeAI/VOICE/tien/tien_1.mp3",
        "2000": "/home/pi/CodeAI/VOICE/tien/tien_2.mp3",
        "5000": "/home/pi/CodeAI/VOICE/tien/tien_5.mp3",
        "10000": "/home/pi/CodeAI/VOICE/tien/tien_10.mp3",
        "20000": "/home/pi/CodeAI/VOICE/tien/tien_20.mp3",
        "50000": "/home/pi/CodeAI/VOICE/tien/tien_50.mp3",
        "100000": "/home/pi/CodeAI/VOICE/tien/tien_100.mp3",
        "200000": "/home/pi/CodeAI/VOICE/tien/tien_200.mp3",
        "500000": "/home/pi/CodeAI/VOICE/tien/tien_500.mp3",
        "khong": "/home/pi/CodeAI/VOICE/tien/tien_khongthanhcong.mp3",
    }
    if score < 0.8:
        money_label = "khong"

    if money_label in audio_files:
        audio_path = audio_files[money_label]
        playsound(audio_path)
    else:
        print("Không có âm thanh cho mệnh giá này.")

def preprocess_image(image):
    image = image.astype(np.float32) / 255.0
    return image

def run_inference_for_single_image(interpreter, image):
    image = cv2.resize(image, (input_details[0]['shape'][2], input_details[0]['shape'][1]))
    image = np.expand_dims(image, axis=0)
    interpreter.set_tensor(input_details[0]['index'], image)
    interpreter.invoke()
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

def process_image(image_path, imgname):
    image_np = load_image_into_numpy_array(image_path)
    image_np = cv2.resize(image_np, dsize=None, fx=0.3, fy=0.3)
    image_np_preprocessed = preprocess_image(image_np.copy())  # Create a copy for preprocessing and inference
    output_dict = run_inference_for_single_image(interpreter, image_np_preprocessed)
    max_score_index = np.argmax(output_dict['StatefulPartitionedCall:1'])
    max_score_class_id = (output_dict['StatefulPartitionedCall:2'][0][max_score_index] + 1).astype(np.int64)
    max_score_class = category_index[max_score_class_id]['name']
    max_score = output_dict['StatefulPartitionedCall:1'][0][max_score_index]
    vis_util.visualize_boxes_and_labels_on_image_array(
      image_np,
      np.squeeze(output_dict['StatefulPartitionedCall:3']),
      np.squeeze((output_dict['StatefulPartitionedCall:2'] + 1).astype(np.int64)),
      np.squeeze(output_dict['StatefulPartitionedCall:1']),
      category_index,
      use_normalized_coordinates=True,
      line_thickness=8)
    image_pil = Image.fromarray(np.uint8(image_np)).convert('RGB')
    resultname = "/home/pi/CodeAI/results/" + imgname
    image_pil.save(resultname)
    return max_score_class, max_score

GPIO.setmode(GPIO.BOARD)

buttonPin1 = 22
buttonPin2 = 12

GPIO.setup(buttonPin1, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(buttonPin2, GPIO.IN, pull_up_down=GPIO.PUD_UP)

buttonPressTime1 = 0
buttonPressTime2 = 0
demo_process = None

while True:
    buttonState1 = GPIO.input(buttonPin1)
    buttonState2 = GPIO.input(buttonPin2)

    if buttonState1 == False:
        buttonPressTime1 = time.time()
        while GPIO.input(buttonPin1) == False:
            pass

        elapsedTime1 = time.time() - buttonPressTime1

        if elapsedTime1 < 0.3:
            if demo_process is None or demo_process.poll() is not None:
                alarm(ALARM_SOUND_BD)
                time.sleep(2)
                demo_process = subprocess.Popen(['python3', '/home/pi/Desktop/demo.py'])
            else:
                demo_process.kill()
                demo_process.wait()
                demo_process = None
                alarm(ALARM_SOUND_KT)

    if buttonState2 == False:
        buttonPressTime2 = time.time()
        while GPIO.input(buttonPin2) == False:
            pass

        elapsedTime2 = time.time() - buttonPressTime2

        if elapsedTime2 < 0.3:
            if demo_process is None or demo_process.poll() is not None:
                alarm(ALARM_SOUND_TIEN_BD)
                image_path, img_name = capture_image()
                money, score = process_image(image_path, img_name)
                print(money)
                print(score)
                convert_to_audio(money, score)
            else:
                demo_process.kill()
                demo_process.wait()
                demo_process = None
                alarm(ALARM_SOUND_TIEN_KT)

    time.sleep(0.1)
