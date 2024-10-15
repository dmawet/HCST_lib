from pipython import GCSDevice, GCSError
import time

ipaddress = '131.215.193.165'

with GCSDevice() as dev:
    dev = GCSDevice()
    # dev.ConnectUSB(<serial_number>)
    dev.ConnectTCPIP(ipaddress, ipport=50000)

    #Query Range
    min = dev.qTMN()
    max = dev.qTMX()

    print(min,'\n', max, '\n', min['A'])

    # List of axes
    axes = ['A', 'B'];

    # Close the internal SGS loops
    dev.SVO({axis:True for axis in axes})
    #
    Query Loop status
    dev.qSVO(axes)

    # Query current position
    dev.qPOS(axes)
    time.sleep(3)

    # command to new position
      # (Apply fraction of full range)
    newPos = [0,0]
    for ind, axis in enumerate(axes):
        newPos[ind] = 0.01*(max[axis]-min[axis])
    print(dev.qSVO(axes),'\n')
    print({axis:newPos[ind] for ind, axis in enumerate(axes)})
    # (NOTE: the MOV command only works in closed loop)
    dev.MOV({axis:newPos[ind] for ind, axis in enumerate(axes)})

    time.sleep(1)
    dev.qPOS(axes)

    #-- Cleanup before disconnecting
    # Open Loops
    dev.SVO({axis:False for axis in axes})
    # Zero voltages (only really needed if fully shutting down power)
    dev.SVA({axis:0 for axis in axes})
    # Disconnect
    dev.CloseConnection()



#####
# Test wiggle:
# command to new position
# (Apply fraction of full range)
# for i in range(1000):
#     if (num % 2) == 0:
#         sign = 1
#     else:
#         sign = -1
#
#     newPos = []
#     newPos[0] = sign * 0.3 * (max[0] - min[0])
#     newPos[1] = 0.3 * (max[1] - min[1])
#
#     # (NOTE: the MOV command only works in closed loop)
#     dev.MOV({axis:newPos[ind] for ind, axis in enumerate(axes)})
