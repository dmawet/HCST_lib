import pipython
import numpy as np
import time
from scipy import io as sio
import atexit
import matplotlib.pyplot as plt
plt.ion()

# Define a function to close connection no matter what
def closeFunc():
    global dev
    try:
        dev.CloseConnection()
        print("Connection Closed Successfully")
    except Exception as e:
        print("ERROR: {}".format(e))

# Read the chirp signal file
chirp_mat = sio.loadmat("chirp_300Hz.mat")
chirp_sig = chirp_mat["u_chirp"].T[:,0]	# Transpose to get col vec
# Define scaling factor for amplitude of signal
amp_scale = 1
# Define offset position for signal
offset = 5
# Define native frequency of signal
sig_freq = 300  # [Hz]
# Define early breaking point for signal (optional: set >sig_length to disable this)
MaxInd = 30000

sig_length = chirp_sig.shape[0]
chirp_sig *= amp_scale
chirp_sig += offset
#print(chirp_sig)
print("Max: {} | Min: {} | PV: {}".format(chirp_sig.max(), chirp_sig.min(), np.ptp(chirp_sig)))
print("Signal Length: {}".format(sig_length))


# Preallocate output array
results = np.nan * np.zeros((sig_length,7))

# Compute sample time from frequency
delT = 1/sig_freq

# Connect to the mirror
dev = pipython.GCSDevice()
#dev.ConnectTCPIP("131.215.193.165", ipport=50000)
dev.ConnectUSB("116035074")
# Register close function  now that we've nominally connected
atexit.register(closeFunc)
# Confirm connect
print(dev.qIDN())

# Preallocate axes to control
axesONL = ["1", "2"]
axes = ["A", "B"]
nonSigPos = 5

# Set up mirror for closed loop motion
dev.ONL({ax:True for ax in axesONL}) # bring axes online
dev.SVO({ax:True for ax in axes}) # close loops (servos) for axes

# Move to starting position (to avoid large jump at start)
dev.MOV({axes[0]:nonSigPos, axes[1]:chirp_sig[0]})
time.sleep(2)

# Disable error check in library (to be able to run faster...)
dev.SetErrorCheck(False)

# Main loop to inject signal
t0 = time.time()
for ind, sig_val in enumerate(chirp_sig):
    # Get timestamp on this itr
    results[ind,0] = time.time()

    # Inject chirp signal
    movPos = {axes[0]:nonSigPos, axes[1]:sig_val}
    dev.MOV(movPos)

    # Query voltages
    vol = dev.qVOL(axesONL)
    # Query SGS position
    #pos = dev.qPOS(axes)

    # Put data into output array
    results[ind,1] = movPos[axes[0]]
    results[ind,2] = movPos[axes[1]]
    results[ind,3] = vol[axesONL[0]]
    results[ind,4] = vol[axesONL[1]]
    #results[ind,5] = pos[axes[0]]
    #results[ind,6] = pos[axes[1]]

    # Now wait until to apply signal so we apply at given goal frequency
        # Note: this is NOT a high-fidelity way to do this, but good enough for this test
    time_passed = time.time() - results[ind,0]
    sleep_time = delT - time_passed
    try:
        time.sleep(sleep_time-0.0001)   # add some buffer to the sleep
    except ValueError as e:
        print("Too Slow: {}".format(e))

    if ind > MaxInd:
	# Break early if requested
        break

# Set error check back on
dev.SetErrorCheck(True)

dev.MOV({ax:0.05 for ax in axes})


# Plot Results
plt.figure()
plt.title("Injected 1")
plt.plot((results[:,0]-results[0,0]), results[:,1])


plt.figure()
plt.title("Injected 2")
plt.plot((results[:,0]-results[0,0]), results[:,2])


plt.figure()
plt.title("Measured 3")
plt.plot((results[:,0]-results[0,0]), results[:,3])


plt.figure()
plt.title("Measured 4")
plt.plot((results[:,0]-results[0,0]), results[:,4])
