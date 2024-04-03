#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <xdo.h>
#include <libevdev-1.0/libevdev/libevdev.h>

int main() {
        struct libevdev *dev = libevdev_new();
        int fd;
        int rc;

        // Opening input device
        if(fd = open("/dev/input/event0", O_RDWR|O_NONBLOCK) < 0) {
                printf("Failed to open input device!\n");
                return 1;
        }
        else {
                printf("Input device opened successfully.\n");
        }

        // Initializing libevdev
        if(rc = libevdev_set_fd(dev, fd) < 0) {
                printf("Failed to initialize libevdev!\n");
                return 1;
        }
        else {
                printf("libevdev initialized successfully.\n");
        }

        // Test
        xdo_t * x = xdo_new(NULL);

        xdo_enter_text_window(x, CURRENTWINDOW, "Hi", 1000);
        xdo_free(x);

        close(fd);

        return 0;
}
