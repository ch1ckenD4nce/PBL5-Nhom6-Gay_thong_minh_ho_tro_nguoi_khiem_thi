import serial
import pynmea2

# Thiết lập cổng UART
ser = serial.Serial('/dev/serial0', baudrate=9600, timeout=1)

try:
    while True:
        # Đọc dữ liệu từ mô-đun GPS
        data = ser.readline().decode('utf-8')
        #print(data)
        
        # Kiểm tra xem dữ liệu có phải là dữ liệu GPS không
        if data.startswith('$GPGGA'):
            # Giải mã dữ liệu GPS
            msg = pynmea2.parse(data)
            latitude = msg.latitude
            longitude = msg.longitude
            altitude = msg.altitude
            print("Latitude:", latitude)
            print("Longitude:", longitude)
            print("Altitude:", altitude, "m")
        
except KeyboardInterrupt:
    ser.close()
    print("Đã kết thúc chương trình.")
    

