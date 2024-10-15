from pipython import GCSDevice, GCSError


class TTM_device(GCSDevice):
    def __init__(self, devname='', gcsdll='', gateway=None):
        super.__init__(self, devname='', gcsdll='', gateway=None)

    def SU_CL(self):
        axesONL = ["1", "2"]
        axes = ["A", "B"]

        # Set up mirror for closed loop motion
        self.ONL({ax: True for ax in axesONL})  # bring axes online
        self.SVO({ax: True for ax in axes})  # close loops (servos) for axes

    def MOV_TT(self, tip, tilt):
        self.MOV(['A', 'B'], [tip,tilt])

    def __enter__(self):
        self.init()
        return self

    def __exit__(self, _type, value, traceback):
        self.CloseConnection()
        try:
            self.CloseConnection()
            print("Connection Closed Successfully")
        except Exception as e:
            print("ERROR: {}".format(e))