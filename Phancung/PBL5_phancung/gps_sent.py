

import pyrebase
import serial
import pynmea2
import time

firebaseConfig = {
    "apiKey": "AIzaSyCBYfHvB5n8n4El3gPiS8wZxqSaXYK-mDs",
    "authDomain": "gps-app-2-c781f.firebaseapp.com",
    "databaseURL": "https://gps-app-2-c781f-default-rtdb.firebaseio.com",
    "storageBucket": "gps-app-2-c781f.appspot.com"
}

firebase = pyrebase.initialize_app(firebaseConfig)
db = firebase.database()

while True:
    ser = serial.Serial('/dev/serial0', baudrate=9600, timeout=1)
    dataout = pynmea2.NMEAStreamReader()
    newdata = ser.readline()
    n_data = newdata.decode('latin-1')
    if n_data[0:6] == '$GPRMC':
        newmsg = pynmea2.parse(n_data)
        lat = newmsg.latitude
        lng = newmsg.longitude
        gps = "Latitude=" + str(lat) + " and Longitude=" + str(lng)
        print(gps)
        data = {"LAT": lat, "LNG": lng}
        timestamp = int(time.time() * 1000)
        if lat != 0 and lng != 0:
            db.child("GPS").child("102210111").child(timestamp).set(data)
            print("Data sent")
            time.sleep(10) 
        
