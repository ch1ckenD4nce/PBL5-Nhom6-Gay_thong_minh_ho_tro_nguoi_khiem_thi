from gpiozero import DistanceSensor
from time import sleep
import pygame.mixer

ALARM_SOUND_2m5 = "/home/pi/Desktop/VOICE/vatcan/vatcan_2.5.mp3"
ALARM_SOUND_2m = "/home/pi/Desktop/VOICE/vatcan/vatcan_2.mp3"
ALARM_SOUND_1m5 = "/home/pi/Desktop/VOICE/vatcan/vatcan_1.5.mp3"
ALARM_SOUND_1m = "/home/pi/Desktop/VOICE/vatcan/vatcan_1.mp3"
ALARM_SOUND_50 = "/home/pi/Desktop/VOICE/vatcan/vatcan_ratgan.mp3"

pygame.mixer.init()

def alarm(sound_file):
    pygame.mixer.music.load(sound_file)
    pygame.mixer.music.play()

sensor = DistanceSensor(echo=23, trigger=24, max_distance=3) 

while True:
    value = sensor.distance * 100
    
    if value <= 50:
        alarm(ALARM_SOUND_50)
    elif value <= 100:
        alarm(ALARM_SOUND_1m)
    elif value <= 150:
        alarm(ALARM_SOUND_1m5)
    elif value <= 200:
        alarm(ALARM_SOUND_2m)
    elif value <= 250:
        alarm(ALARM_SOUND_2m5)
	
    print('Distance to nearest object is: ', value, 'cm')
    sleep(4)
