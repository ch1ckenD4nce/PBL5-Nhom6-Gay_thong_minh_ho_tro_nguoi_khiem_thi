import RPi.GPIO as GPIO
import time
import subprocess
import pygame.mixer

ALARM_SOUND_st = "/home/pi/Desktop/MP3/start.mp3"
ALARM_SOUND_BD = "/home/pi/Desktop/MP3/BD.mp3"
ALARM_SOUND_KT = "/home/pi/Desktop/MP3/KT.mp3"
ALARM_SOUND_TIEN_BD = "/home/pi/Desktop/MP3/tienBD.mp3"
ALARM_SOUND_TIEN_KT = "/home/pi/Desktop/MP3/tienKT.mp3"
print("main")
def alarm(sound_file):
    pygame.mixer.init()  # Khởi tạo mixer của pygame
    pygame.mixer.music.load(sound_file)
    pygame.mixer.music.play()

alarm(ALARM_SOUND_st)
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
        while GPIO.input(buttonPin1) == False:  # Kiểm tra nếu nút vẫn được nhấn
            pass

        elapsedTime1 = time.time() - buttonPressTime1

        if elapsedTime1 < 0.3:  # Nhấn ngắn
            if demo_process is None or demo_process.poll() is not None:  # Kiểm tra nếu quá trình demo không chạy hoặc đã kết thúc
                alarm(ALARM_SOUND_BD)
                time.sleep(2)
                demo_process = subprocess.Popen(['python3', '/home/pi/Desktop/demo.py'])
            else:  # Nếu quá trình demo đang chạy, dừng nó
                demo_process.kill()
                demo_process.wait()  # Chờ quá trình kết thúc hoàn toàn
                demo_process = None
                alarm(ALARM_SOUND_KT)

    if buttonState2 == False:
        buttonPressTime2 = time.time()
        while GPIO.input(buttonPin2) == False:  # Kiểm tra nếu nút vẫn được nhấn
            pass

        elapsedTime2 = time.time() - buttonPressTime2

        if elapsedTime2 < 0.3:  # Nhấn ngắn
            if demo_process is None or demo_process.poll() is not None:  # Kiểm tra nếu quá trình demo không chạy hoặc đã kết thúc
                alarm(ALARM_SOUND_TIEN_BD)
                demo_process = subprocess.Popen(['python3', '/home/pi/CodeAI/SSD_622_16_13/new.py'])
            else:  # Nếu quá trình demo đang chạy, dừng nó
                demo_process.kill()
                demo_process.wait()  # Chờ quá trình kết thúc hoàn toàn
                demo_process = None
                alarm(ALARM_SOUND_TIEN_KT)

    time.sleep(0.1)  # Tạm dừng để tránh chi phí xử lý CPU quá cao
