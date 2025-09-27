from pylibftdi import Device, Driver
import time

class FtdiEmulInterface: # FTDI Sync FIFO -> Bus master interface
    def __init__(self, iface = None):
        self.interface  = iface
        self.target     = None
        self.prog_cb    = None
        self.CMD_NOP    = 0x0
        self.CMD_WR     = 0x1
        self.CMD_RD     = 0x2
        self.CMD_GP_WR  = 0x3
        self.CMD_GP_RD  = 0x4
        self.HDR_SIZE   = 6
        self.MAX_SIZE   = 255
        self.BLOCK_SIZE_WR = 64 # Really 2048
        self.BLOCK_SIZE_RD = 64
        self.MAGIC_ADDR = 0xF0000000

        # User specified (device_id)
        self.dev_id     = None
        if iface != None and iface != "":
            self.dev_id = iface

    def connect(self): # Open serial connection
        # self.target = Device(device_id=self.dev_id,interface_select=1)
        # self.target.flush()
        # time.sleep(0.01)

        BITMODE_SYNCFF = 0x40
        SIO_RTS_CTS_HS = (0x1 << 8)
        # self.target.ftdi_fn.ftdi_set_bitmode(0, BITMODE_SYNCFF)
        # self.target.ftdi_fn.ftdi_setflowctrl(SIO_RTS_CTS_HS)
        # self.target.flush()

    def read32(self, addr): # Read a word from a specified address
        if self.target == None: # Connect if required
            self.connect()

        # Send read command
        cmd = bytearray([self.CMD_RD, 
                         4, 
                        (addr >> 24) & 0xFF, 
                        (addr >> 16) & 0xFF, 
                        (addr >> 8) & 0xFF, 
                        (addr >> 0) & 0xFF])
        # self.target.write(cmd)

        value = 0
        idx   = 0
        while (idx < 4):
            # b = self.target.read(1)
            b = b'\x00'
            value |= (ord(b) << (idx * 8))
            idx += 1

        return value

    def write32(self, addr, value): # Write a word to a specified address
        if self.target == None: # Connect if required
            self.connect()

        # Send write command
        cmd = bytearray([self.CMD_WR,
                         4, 
                        (addr >> 24)  & 0xFF, 
                        (addr >> 16)  & 0xFF, 
                        (addr >> 8)   & 0xFF, 
                        (addr >> 0)   & 0xFF, 
                        (value >> 0)  & 0xFF, 
                        (value >> 8)  & 0xFF, 
                        (value >> 16) & 0xFF, 
                        (value >> 24) & 0xFF])
        # self.target.write(cmd)