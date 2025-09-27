import sys

from ftdi_sync_interface import *
from ftdi_emul_interface import *

class BusInterface: # Bus interface wrapper
    def __init__(self, iface_type = 'ftdi', iface = None):
        if iface_type == "ftdi":
            self.bus = FtdiSyncInterface(iface)            
        elif iface_type == "emul":
            self.bus = FtdiEmulInterface(iface)            
        else:
            raise ValueError('Invalid interface type specified !(ftdi|emul).')

    def read32(self, addr):
        return self.bus.read32(addr)

    def write32(self, addr, value):
        return self.bus.write32(addr, value)