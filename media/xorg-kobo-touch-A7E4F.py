#!/usr/bin/python3
from Xlib import X
from Xlib.display import Display
from Xlib.ext.xtest import fake_input
from evdev import InputDevice, categorize, ecodes
from evdev.events import AbsEvent, KeyEvent
from evdev.ecodes import ABS

# find max values
def get_max_values(dev):
    xmax = 0
    ymax = 0
    cap = dev.capabilities(verbose=True)
    for key, value in cap.items():
        for entry in value:
            if entry[0][0] == 'ABS_MT_POSITION_X':
                xmax = entry[1].max
            if entry[0][0] == 'ABS_MT_POSITION_Y':
                ymax = entry[1].max
    return xmax, ymax
     

# apply touchscreen transform
def transform_input(x, y, xmax, ymax):
    # normalize values
    xn = float(x) / xmax
    yn = float(y) / ymax
    
    
    # platform specific transform
    # KA1
    xt = (1-yn) * ymax
    yt = xn * xmax
    
    
    return int(xt), int(yt)

d = Display()
s = d.screen()
root = s.root

dev = InputDevice('/dev/input/event1')
print(dev)
print(dev.capabilities(verbose=True))

x = 0
y = 0
xmax, ymax = get_max_values(dev)
for event in dev.read_loop():
    cat = categorize(event)
    #print(cat)
    #print(event)
    val = event.value
    if isinstance(cat, AbsEvent):        
        # update mouse positions        
        if ABS[event.code] == 'ABS_MT_POSITION_X':
            if x != val:
                x = val
                xt, yt = transform_input(x, y, xmax, ymax);
                #move pointer to set location
                root.warp_pointer(xt, yt)
                d.sync()
                print("mousemove {0} {1}".format(x, y))
            
        if ABS[event.code] == 'ABS_MT_POSITION_Y':
            if y != val:
                y = val
                xt, yt = transform_input(x, y, xmax, ymax);
                #move pointer to set location
                root.warp_pointer(xt, yt)
                d.sync()
                print("mousemove {0} {1}".format(x, y))
            
    if isinstance(cat, KeyEvent):
        ks = ('up', 'down', 'hold')[cat.keystate]
        
        # register mousedown event
        if ks == 'down':
            xt, yt = transform_input(x, y, xmax, ymax);
            fake_input(d, X.ButtonPress, 1)
            d.sync()
            print("mousedown {0} {1}".format(xt, yt))
            
        # register mouseup event
        if ks == 'up':
            xt, yt = transform_input(x, y, xmax, ymax);
            fake_input(d, X.ButtonRelease, 1)
            d.sync()
            print("mouseup {0} {1}".format(xt, yt))
