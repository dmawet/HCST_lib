n = 0
v = 0
string = ""
string += 'Time,'
list = ["Temp","Humidity","Pressure","X Accel","Y Accel","Z Accel","X Gyro","Y Gyro","Z Gyro","X Mag","Y Mag","Z Mag"]
while n < 8:
    while v < len(list):
        string += (list[v]+" S"+str(n)+',')
        v += 1
    n += 1
    v = 0

string = string[:len(string)-1]
print string
print
